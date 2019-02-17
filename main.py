import json
import logging
import os
import socket
from typing import List

import sqlalchemy
from flask import Flask, abort, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Column, ForeignKey, Integer, String, Table, inspect
from sqlalchemy.orm import backref, relationship

from flask_migrate import Migrate

app = Flask(__name__)

# Environment variables are defined in app.yaml.
app.config["SQLALCHEMY_DATABASE_URI"] = os.environ["SQLALCHEMY_DATABASE_URI"]
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)


endorsement = Table(
    "endorsements",
    db.metadata,
    Column("receiver_id", Integer, ForeignKey("users.id"), primary_key=True),
    Column("endorser_id", Integer, ForeignKey("users.id"), primary_key=True),
)


class User(db.Model):
    __tablename__ = "users"

    id = Column(Integer, nullable=False, primary_key=True)
    email = Column(String(100), nullable=False)
    name = Column(String(50), nullable=False)
    courses = Column(String(50), nullable=False)
    endorsement_level = Column(Integer, nullable=False)
    studysession_id = Column(Integer, ForeignKey("studysession.id"))
    studysession = relationship("StudySession", back_populates="host_user")

    given_endorsements = relationship(
        "User",
        secondary=endorsement,
        primaryjoin=(id == endorsement.c.endorser_id),
        secondaryjoin=(id == endorsement.c.receiver_id),
    )

    def __init__(self, name: str, email: str, courses: str):
        self.name = name
        self.email = email
        self.courses = courses
        self.endorsement_level = 0
        self.given_endorsements = []

    def __repr__(self):
        return f"User({self.id}, {self.courses}, {self.endorsement_level})"


class StudySession(db.Model):
    __tablename__ = "studysession"

    id = Column(Integer, nullable=False, primary_key=True)
    title = Column(String(50), nullable=False)
    courses = Column(String(50), nullable=False)
    start_time = Column(String(30), nullable=False)
    end_time = Column(String(30), nullable=False)
    building = Column(String(50), nullable=False)
    location = Column(String(100))
    notes = Column(String(200))

    host_user = relationship(
        "User", uselist=False, back_populates="studysession"
    )
    users = relationship("User")

    def __init__(
        self,
        courses: str,
        title: str,
        start_time: str,
        end_time: str,
        host_user: User,
        building: str,
        location: str,
        notes: str,
    ):

        self.courses = courses
        self.title = title
        self.start_time = start_time
        self.end_time = end_time
        self.host_user = host_user
        self.building = building
        self.location = location
        self.notes = notes
        self.users = [host_user]


@app.route("/")
def index():
    return "hey, no one should look at this"


@app.route("/getuser/", methods=["GET"])
def get_user():
    name = request.args.get("name")

    user = User.query.filter_by(name=name).first_or_404()

    new_info = {"name": user.name, "email": user.email, "courses": user.courses}

    return json.dumps(new_info), 200


@app.route("/newuser/", methods=["POST"])
def new_user():
    name = request.args.get("name")
    courses = request.args.get("courses")
    email = request.args.get("email")

    u = User(name=name, email=email, courses=courses)

    db.session.add(u)
    db.session.commit()

    return json.dumps(u.id), 200


@app.route("/getsessions/", methods=["GET"])
def getsessions():
    courses = request.args.get("courses")

    if courses is None:
        results = StudySession.query.all()
    else:
        course_list = courses.split(";")
        result_set = set()
        for course in course_list:
            result_set.update(
                StudySession.query.filter(
                    StudySession.courses.contains(course)
                ).all()
            )
        results = list(result_set)

    simple_results = [
        {
            "id": result.id,
            "title": result.title,
            "start_time": result.start_time,
            "end_time": result.end_time,
            "building": result.building,
            "courses": result.courses,
        }
        for result in results
    ]

    return (
        json.dumps(simple_results),
        200,
        {"Content-Type": "text/plain; charset=utf-8"},
    )


@app.route("/sessioninfo/", methods=["GET"])
def sessioninfo():
    id = request.args.get("id")
    if id is None:
        abort(404)

    ss = StudySession.query.get(id)
    if ss is None:
        abort(404)

    user_list = [
        {"name": u.name, "id": u.id, "is_endorsed": False} for u in ss.users
    ]

    result = {
        "courses": ss.courses,
        "title": ss.title,
        "start_time": ss.start_time,
        "end_time": ss.end_time,
        "users": user_list,
        "building": ss.building,
        "location": ss.location,
        "notes": ss.notes,
    }

    return (
        json.dumps(result),
        200,
        {"Content-Type": "text/plain; charset=utf-8"},
    )


@app.route("/newsession/", methods=["POST"])
def newsession():
    courses = request.args.get("courses")
    title = request.args.get("title")
    start_time = request.args.get("start_time")
    end_time = request.args.get("end_time")
    host_user_name = request.args.get("host_user")
    building = request.args.get("building")
    location = request.args.get("location")
    notes = request.args.get("notes")

    if title is None:
        return "undefined title", 500
    if courses is None:
        return "undefined courses", 500
    if start_time is None or end_time is None:
        return "undefined time", 500
    if host_user_name is None:
        return "undefined host", 500
    if building is None:
        return "undefined building", 500

    host_user = User.query.filter_by(name=host_user_name).first()

    ss = StudySession(
        courses=courses,
        title=title,
        start_time=start_time,
        end_time=end_time,
        host_user=host_user,
        building=building,
        location=location or "",
        notes=notes or "",
    )

    db.session.add(ss)
    db.session.commit()

    return json.dumps(ss.id), 201


@app.route("/endorse/", methods=["PUT"])
def endorse():
    endorser = request.args.get("endorser")
    receiver = request.args.get("receiver")
    u_endorser = User.query.filter_by(name=endorser).first()
    u_receiver = User.query.filter_by(name=receiver).first()
    if u_receiver not in u_endorser.given_endorsements:
        u_endorser.given_endorsements.append(u_receiver)
        u_receiver.endorsement_level += 1
        db.session.commit()
    return json.dumps(u_endorser.id), 204


@app.route("/unendorse/", methods=["PUT"])
def unendorse():
    unendorser = request.args.get("unendorser")
    receiver = request.args.get("receiver")
    u_unendorser = User.query.filter_by(name=unendorser).first()
    u_receiver = User.query.filter_by(name=receiver).first()
    if u_receiver not in u_unendorser.given_endorsements:
        u_unendorser.given_endorsements.append(u_receiver)
        u_receiver.endorsement_level -= 1
        db.session.commit()
    return json.dumps(u_unendorser.id), 204


@app.route("/modifyuser/", methods=["PUT"])
def modify():
    name = request.args.get("name")
    new_email = request.args.get("newemail")
    new_courses = request.args.get("newcourses")
    new_name = request.args.get("newname")

    if name is None:
        abort(404)

    user = User.query.filter_by(name=name).first()

    if new_email is not None:
        user.email = new_email
    if new_courses is not None:
        user.courses = new_courses
    if new_name is not None:
        user.name = new_name

    db.session.commit()

    new_info = {"name": user.name, "email": user.email, "courses": user.courses}

    return json.dumps(new_info), 200

@app.route("/usercourses/", methods=["GET"])
def user_courses():
    name = request.args.get("name")

    if name is None:
        abort(404)

    user = User.query.filter_by(name=name).first()

    courses = user.courses

    return courses, 200


@app.errorhandler(500)
def server_error(e):
    logging.exception("An error occurred during a request.")
    return (
        """
    An internal error occurred: <pre>{}</pre>
    See logs for full stacktrace.
    """.format(
            e
        ),
        500,
    )


if __name__ == "__main__":
    db.create_all()
    # This is used when running locally. Gunicorn is used to run the
    # application on Google App Engine. See entrypoint in app.yaml.
    app.run(host="127.0.0.1", port=8080, debug=True)

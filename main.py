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
    'endorsements',
    db.metadata,
    Column('receiver_id', Integer, ForeignKey('users.id'), primary_key=True),
    Column('endorser_id', Integer, ForeignKey('users.id'), primary_key=True)
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

    given_endorsements = relationship("User",
        secondary=endorsement,
        primaryjoin=(id==endorsement.c.endorser_id),
        secondaryjoin=(id==endorsement.c.receiver_id)
    )

    def __init__(self, name: str, email: str, courses: str):
        self.name = name
        self.email = email
        self.courses = courses
        self.endorsement_level = 0
        self.given_endorsements = []

    def __repr__(self):
        return f"User({self.id}, {self.courses}, {self.endorsement_level})"


"""
class Endorsements(db.Model):
    __tablename__ = 'endorsement'
    id = Column(Integer, primary_key=True)
    receiver_id = Column(Integer, ForeignKey('user.id'))
    endorser_id = Column(Integer, ForeignKey('user.id'))

    receiver = relationship(User, backref=backref('endorsement', cascade='all, delete-orphan'))
    endorser = relationship(User, backref=backref('user', cascade='all, delete-orphan'))
"""


class StudySession(db.Model):
    __tablename__ = "studysession"

    id = Column(Integer, nullable=False, primary_key=True)
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
        start_time: str,
        end_time: str,
        host_user: User,
        building: str,
        location: str,
        notes: str,
        users: List[User],
    ):

        self.courses = courses
        self.start_time = start_time
        self.end_time = end_time
        self.host_user = host_user
        self.building = building
        self.location = location
        self.notes = notes
        self.users = users


@app.route("/")
def index():
    return "hey, no one should look at this"


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

    # do some magic query

    results = StudySession.query.all()

    simple_results = [
        {
            "id": result.id,
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
    start_time = request.args.get("start_time")
    end_time = request.args.get("end_time")
    host_user_name = request.args.get("host_user")
    user_names = request.args.get("users")
    building = request.args.get("building")
    location = request.args.get("location")
    notes = request.args.get("notes")

    if courses is None:
        return "undefined courses", 404
    if start_time is None or end_time is None:
        return "undefined time", 404
    if host_user_name is None:
        return "undefined host", 404
    if user_names is None:
        return "undefined users", 404
    if building is None:
        return "undefined building", 404

    host_user = User.query.filter_by(name=host_user_name).first_or_404()
    split_user_names = user_names.split(";")
    print(split_user_names)
    users = [
        User.query.filter_by(name=uname).first() for uname in split_user_names
    ]

    ss = StudySession(
        courses=courses,
        start_time=start_time,
        end_time=end_time,
        host_user=host_user,
        building=building,
        location=location or "",
        notes=notes or "",
        users=users,
    )

    db.session.add(ss)
    db.session.commit()

    return json.dumps(ss.id), 201

@app.route('/endorse/', methods=['PUT'])
def endorse():
    endorser = request.args.get('endorser')
    receiver = request.args.get('receiver')
    u_endorser = User.query.filter_by(name=endorser).first()
    u_receiver = User.query.filter_by(name=receiver).first()
    if u_receiver not in u_endorser.given_endorsements:
        u_endorser.given_endorsements.append(u_receiver)
        u_receiver.endorsement_level += 1
        db.session.commit()
    return json.dumps(u_endorser.id), 202

@app.route('/unendorse/', methods=['PUT'])
def unendorse():
    unendorser = request.args.get('unendorser')
    receiver = request.args.get('receiver')
    u_unendorser = User.query.filter_by(name=unendorser).first()
    u_receiver = User.query.filter_by(name=receiver).first()
    if u_receiver not in u_unendorser.given_endorsements:
        u_unendorser.given_endorsements.append(u_receiver)
        u_receiver.endorsement_level -= 1
        db.session.commit()
    return json.dumps(u_unendorser.id), 202

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

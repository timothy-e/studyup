import datetime
import logging
import os
import socket
from datetime import datetime
from typing import List

import sqlalchemy
from flask import Flask, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import (Column, DateTime, ForeignKey, Integer, String, Table,
                        inspect)
from sqlalchemy.orm import backref, relationship

from flask_migrate import Migrate

app = Flask(__name__)

# [START gae_flex_mysql_app]
# Environment variables are defined in app.yaml.
app.config["SQLALCHEMY_DATABASE_URI"] = os.environ["SQLALCHEMY_DATABASE_URI"]
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)


class User(db.Model):
    __tablename__ = "user"

    id = Column(Integer, nullable=False, primary_key=True)
    courses = Column(String(50), nullable=False)
    endorsement_level = Column(Integer, nullable=False)
    studysession_id = Column(Integer, ForeignKey("studysession.id"))
    studysession = relationship("StudySession", back_populates="host_user")

    # given_endorsements = relationship("User", secondary="user")

    def __init__(self, courses: List[str]):
        self.courses = courses
        self.endorsement_level = 0
        # self.given_endorsements = []

    def __repr__(self):
        return f"User({self.id}, {self.courses}, {self.endorsement_level}"


class Endorsements(db.Model):
    __tablename__ = 'endorsement'
    id = Column(Integer, primary_key=True)
    receiver_id = Column(Integer, ForeignKey('user.id'))
    endorser_id = Column(Integer, ForeignKey('user.id'))

    receiver = relationship(User, backref=backref('endorsement', cascade='all, delete-orphan'))
    endorser = relationship(User, backref=backref('user', cascade='all, delete-orphan'))


class StudySession(db.Model):
    __tablename__ = "studysession"

    id = Column(Integer, nullable=False, primary_key=True)
    courses = Column(String(50), nullable=False)
    start_time = Column(DateTime, nullable=False)
    end_time = Column(DateTime, nullable=False)
    host_user = relationship(
        "User", uselist=False, back_populates="studysession"
    )
    users = relationship("User")

    def __init__(
        self,
        courses: str,
        start_time: datetime,
        end_time: datetime,
        host_user: User,
        users: List[User],
    ):

        self.courses = courses
        self.start_time = start_time
        self.end_time = end_time
        self.host_user = host_user
        self.users = users


@app.route("/")
def index():
    user = User(courses="CS241;CS251")
    ss = StudySession(courses="CS241", start_time=datetime.now(), end_time=datetime.now(), host_user=user, users=[user])

    db.session.add(user)
    db.session.add(ss)
    db.session.commit()

    users = db.session.query(User).all()

    results = [repr(u) for u in users]

    output = "All Users:\n{}".format("\n".join(results))

    return output, 200, {"Content-Type": "text/plain; charset=utf-8"}


# [END gae_flex_mysql_app]


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
    print("here")

    db.create_all()
    print("blah")
    engine = db.session.get_bind()
    iengine = inspect(engine)

    print(iengine.get_table_names())
    # This is used when running locally. Gunicorn is used to run the
    # application on Google App Engine. See entrypoint in app.yaml.
    app.run(host="127.0.0.1", port=8080, debug=True)

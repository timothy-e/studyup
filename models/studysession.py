from datetime import datetime
from typing import List

from sqlalchemy import Column, DateTime, Integer
from sqlalchemy.orm import relationship

from . import db
from .columns.JSONEncodedObject import JSONEncodedObject
from .user import User


class StudySession(db.Model):
    __tablename__ = "studysession"

    id = Column(Integer, nullable=False, primary_key=True)
    courses = Column(JSONEncodedObject, nullable=False)
    start_time = Column(DateTime, nullable=False)
    end_time = Column(DateTime, nullable=False)
    host_user = relationship(
        "User", uselist=False, back_populates="studysession"
    )
    users = relationship("User")

    def __init__(self,
            courses: List[str],
            start_time: datetime,
            end_time: datetime,
            host_user: User,
            users: List[User]
        ) -> self.cls:

        self.courses = JSONEncodedObject(courses)
        self.start_time = start_time
        self.end_time = end_time
        self.host_user = host_user
        self.users = users

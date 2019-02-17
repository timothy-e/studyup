from typing import List

from sqlalchemy import Column, ForeignKey, Integer, Table
from sqlalchemy.orm import relationship

from . import db
from .columns.JSONEncodedObject import JSONEncodedObject

endorsement_table = Table(
    "association",
    db.metadata,
    Column("recipient_id", Integer, ForeignKey("user.id")),
    Column("endorser_id", Integer, ForeignKey("user.id")),
)


class User(db.Model):
    __tablename__ = "user"

    id = Column(Integer, nullable=False, primary_key=True)
    courses = Column(JSONEncodedObject, nullable=False)
    endorsement_level = Column(Integer, nullable=False)
    studysession_id = Column(Integer, ForeignKey("studysession.id"))

    given_endorsements = relationship("User", secondary=endorsement_table)

    def __init__(self, courses: List[str]) -> self.cls:
        self.courses = JSONEncodedObject(courses)
        self.endorsement_level = 0
        self.given_endorsements = []

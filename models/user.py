from typing import List

from sqlalchemy import Column, ForeignKey, Integer, Table, String
from sqlalchemy.orm import relationship, backref

from . import db

'''
Endorsements = Table(
    'Endorsements', db.metadata,
    Column('')
)
'''


'''
class Endorsements(db.Model):
    __tablename__ = 'endorsement'
    id = Column(Integer, primary_key=True)
    receiver_id = Column(Integer, ForeignKey('user.id'))
    endorser_id = Column(Integer, ForeignKey('user.id'))

    receiver = relationship(User, backref=backref('endorsement', cascade='all, delete-orphan'))
    endorser = relationship(User, backref=backref('user', cascade='all, delete-orphan'))
'''

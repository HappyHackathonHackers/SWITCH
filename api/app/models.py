from sqlalchemy import Column, Integer, String, ARRAY
from .database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    age = Column(Integer)
    university = Column(String)
    major = Column(String)
    country = Column(String)
    interests = Column(ARRAY(String))

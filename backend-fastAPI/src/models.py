from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, Table
from sqlalchemy.orm import relationship
from database import Base



student_course = Table("student_courses", Base.metadata, 
                       Column("student_id", ForeignKey("students.id"), primary_key=True),
                       Column("course_id", ForeignKey("courses.id"), primary_key=True))


class Student(Base):
    __tablename__ = "students"

    id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, unique=True, index=True)
    name = Column(String)
    session = Column(String)
    face_embedding = Column(String)
    courses = relationship("Course", secondary=student_course, back_populates="students")


class Course(Base):
    __tablename__ = "courses"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    code = Column(String)
    students = relationship("Student", secondary=student_course, back_populates="courses")

# class StudentClass(Base):
#     __tablename__ = "studentclasses"

#     student_id = Column(Integer, ForeignKey("students.id"))
#     course_id = Column(Integer, ForeignKey("courses.id"))

# class Teacher(Base):
#     __tablename__ = "teachers"

#     id = Column(Integer, primary_key=True, index=True)
#     name = Column(String)

# class TeacherClass(Base):
#     __tablename__ = "teacherclasses"

#     teacher_id = Column(Integer, ForeignKey("teachers.id"))
#     course_id = Column(Integer, ForeignKey("courses.id"))
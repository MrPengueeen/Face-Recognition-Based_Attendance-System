from pydantic import BaseModel
from datetime import datetime
import schemas


# Teacher Schemas
class TeacherBase(BaseModel):
    
    
    email: str
    

class TeacherCreate(TeacherBase):
    password: str
    user_type: str
    username: str
    name: str

class Teacher(TeacherBase):
    id: int
    name: str
    username: str
    
    class Config:
        orm_mode = True

class TeacherLogin(TeacherBase):
    password: str
    user_type: str


# Student schemas
class StudentBase(BaseModel):
    student_id: int
    name: str
    session: str

class StudentCreate(StudentBase):
    pass

# class StudentSecret(StudentBase):
#     face_embedding: str



class Student(StudentBase):
    id: int
    student_id: int
    name: str
    session: str

    class Config:
        orm_mode = True
    
    def __eq__(self, other):
        return self.id == other.id

class StudentAttendance(Student):
    face: list[int]

# Course Schema
class CourseBase(BaseModel):
    name: str
    code: str
    semester: str
    session: str
    teacher_id: int


class CourseCreate(CourseBase):
    pass

class Course(CourseBase):
    id: int
    name: str
    students: list[schemas.Student]
    created_at: datetime
    teacher_name: str

    class Config:
        orm_mode = True


class Attendance(BaseModel):
    id: int
    course_id: int
    topic: str
    date: datetime
    students: list[schemas.Student]


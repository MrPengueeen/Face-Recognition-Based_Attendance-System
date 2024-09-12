from pydantic import BaseModel
from datetime import datetime
import schemas


# Teacher Schemas
class TeacherBase(BaseModel):
    
    
    email: str
    

class TeacherCreate(TeacherBase):
    password: str

class Teacher(TeacherBase):
    id: int
    name: str
    username: str
    
    class Config:
        orm_mode = True

class TeacherLogin(TeacherBase):
    password: str


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

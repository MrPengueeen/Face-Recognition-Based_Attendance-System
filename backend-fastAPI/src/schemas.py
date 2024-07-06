from pydantic import BaseModel


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

class CourseCreate(CourseBase):
    pass

class Course(CourseBase):
    id: int
    name: str

    class Config:
        orm_mode = True

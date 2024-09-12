from sqlalchemy.orm import Session
from fastapi import HTTPException



import models, schemas

# Student CRUD Operations
def get_students(db: Session, skip: int=0, limit: int=100):
    return db.query(models.Student).offset(skip).limit(limit).all()

def get_student_by_student_id(db: Session, student_id: int):
    return db.query(models.Student).filter(models.Student.student_id == student_id).first()

def create_student(db: Session, student: schemas.StudentCreate, face_embedding: str):
    db_student = models.Student(name=student.name, session=student.session, student_id=student.student_id, face_embedding=face_embedding)
    db.add(db_student)
    db.commit()
    db.refresh(db_student)
    return db_student


# Course CRUD Operations

def get_courses_by_teacher(db: Session, teacher_id: int):
    db_courses = db.query(models.Course).filter(models.Course.teacher_id==teacher_id).all()
    teacher = db.query(models.Teacher).filter(models.Teacher.id==teacher_id).first()
    for db_course in db_courses:
        db_course.teacher_name = teacher.name
    return db_courses
    # # courses = []
    # # for db_course in db_courses:
    # #     course = db_course.__dict__
    # #     teacher = db.query(models.Teacher).filter(models.Teacher.id==db_course.teacher_id).first()
    # #     course['teacher_name'] = teacher.name
    # #     courses.append(course)
    # # return courses
    # return db_courses
def create_course(db: Session, course: schemas.CourseCreate):
    db_course = models.Course(name=course.name, code=course.code, teacher_id=course.teacher_id, semester=course.semester, session=course.session)
    db.add(db_course)
    db.commit()
    db.refresh(db_course)
    return db_course

def add_students_to_course(db: Session, students: list[schemas.Student], course_id: int):
    db_course = db.query(models.Course).filter(models.Course.id == course_id).first()
    
    if not db_course:
        return db_course
    for student in students:
        print(student)
        db_student = db.query(models.Student).filter(models.Student.id==student.id).first()
        db_course.students.append(db_student)
    db.add(db_course)
    db.commit()
    db.refresh(db_course)
    return db_course


# Attendance CRUD Operations
def get_students_by_course_id(db: Session, course_id: int):
    db_course = db.query(models.Course).filter(models.Course.id==course_id).first()
    if not db_course:
        raise HTTPException(status_code=404, detail="No course found for the given course ID")
    
    students = db_course.students
    return students
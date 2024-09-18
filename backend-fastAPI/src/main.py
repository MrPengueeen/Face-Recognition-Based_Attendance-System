from fastapi import FastAPI, Depends, HTTPException, UploadFile, File, Query, Body
from sqlalchemy.orm import Session
import models, schemas, crud, face_recognition_utils
from database import SessionLocal, engine
import json
import utils
from typing import Annotated
import datetime

from deepface.modules import verification as vr

models.Base.metadata.create_all(bind=engine)

threshold = vr.find_threshold('Facenet512', 'euclidean_l2')
print(threshold)

app = FastAPI()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()




@app.post("/register/",  response_model=schemas.Teacher)
def register_user(user: schemas.TeacherCreate, db: Session = Depends(get_db)):
    db_user = db.query(models.Teacher).filter(models.Teacher.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_password = utils.get_password_hash(user.password)
    db_user = models.Teacher(username=user.username, email=user.email, hashed_password=hashed_password, name=user.name, user_type=user.user_type)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@app.post("/login", response_model=schemas.Teacher)
def login_user(user: schemas.TeacherLogin, db: Session = Depends(get_db)):
    print(user.email)
    print(user.password)
    db_user = db.query(models.Teacher).filter(models.Teacher.email == user.email).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="No user found with the email")
    if not utils.verify_password(user.password, db_user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    if (db_user.user_type != "teacher") and (db_user.user_type != "master"):
        raise HTTPException(status_code=401, detail="User is not a teacher")
    return db_user

@app.post("/login_admin", response_model=schemas.Teacher)
def login_user(user: schemas.TeacherLogin, db: Session = Depends(get_db)):
    print(user.email)
    print(user.password)
    db_user = db.query(models.Teacher).filter(models.Teacher.email == user.email).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="No user found with the email")
    if not utils.verify_password(user.password, db_user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    if (db_user.user_type != "master") and (db_user.user_type != "admin"):
        raise HTTPException(status_code=401, detail="User does not have administrative access.")

    return db_user


@app.get("/students/", response_model=list[schemas.Student])
async def get_students(skip: int=0, limit: int=100, db: Session = Depends(get_db)):
    return crud.get_students(db=db, skip=skip, limit=limit)


@app.post("/students", response_model=schemas.Student)
async def create_student(student: schemas.StudentCreate = Depends(), file: UploadFile = File(...),  db: Session = Depends(get_db)):
    db_student = crud.get_student_by_student_id(db=db, student_id=student.student_id)
    if db_student:
        raise HTTPException(status_code=400, detail="User with the same student ID already exists!")
    
    save_path = f"./images/temp.png"
    with open(save_path, "wb+") as file_object:
        file_object.write(file.file.read())
    embedding = face_recognition_utils.generate_face_embedding(save_path)
    if not embedding:
        raise HTTPException(status_code = 400, detail="No faces/multiple faces found in the image")
    embedding_string = json.dumps(embedding)
    print(embedding_string)
    print(json.loads(embedding_string))
    
    return crud.create_student(db=db, student=student, face_embedding = embedding_string)


@app.get("/courses", response_model=list[schemas.Course])
async def get_courses_by_teacher(teacher_id: int, db: Session=Depends(get_db)):
    print(teacher_id)
    return crud.get_courses_by_teacher(db= db, teacher_id=teacher_id)

@app.post("/courses", response_model=schemas.Course)
async def create_course(course: schemas.CourseCreate, db: Session=Depends(get_db)):
    return crud.create_course(db=db, course=course)

@app.post("/courses/student", response_model=schemas.CourseBase)
async def add_student_to_course(course_id: int, students: Annotated[list[schemas.Student], Body()], db: Session=Depends(get_db)):
    print(students)
    print(course_id)
    db_course = crud.add_students_to_course(db=db, students=students, course_id=course_id)
    if not db_course:
        raise HTTPException(status_code=404, detail="The given course ID does not correspond to any existing course")
    return db_course

@app.post("/courses/student/delete", response_model=schemas.CourseBase)
async def delete_students_from_course(course_id: int, students: Annotated[list[schemas.Student], Body()], db: Session=Depends(get_db)):
    print(students)
    print(course_id)
    db_course = crud.remove_students_from_course(db=db, students=students, course_id=course_id)
    if not db_course:
        raise HTTPException(status_code=404, detail="The given course ID does not correspond to any existing course")
    return db_course

@app.post("/attendance", response_model=list[schemas.Student])
async def process_attendance(course_id: int, file: UploadFile=File(...), db: Session = Depends(get_db)):

    save_path = f"./images/attendance.png"
    with open(save_path, "wb+") as file_object:
        file_object.write(file.file.read())
    
    students = crud.get_students_by_course_id(db=db, course_id=course_id)
    present_students = face_recognition_utils.process_attendance_from_image(img_path=save_path, students=students)
    return present_students

@app.post("/submit_attendance", response_model=schemas.Attendance)
async def submit_attendance(course_id: int, students: Annotated[list[schemas.Student], Body()], db: Session=Depends(get_db)):
    return crud.submit_attendance(db=db, course_id=course_id, students = students)

@app.get("/attendance", response_model=list[schemas.Attendance])
async def getAttendance(course_id: int, date: datetime.datetime, db: Session=Depends(get_db)):
    return crud.get_attendance(db=db, course_id=course_id, date=date)

@app.get("/attendance/summary", response_model=list[schemas.Attendance])
async def getAttendanceSummary(course_id: int, db: Session=Depends(get_db)):
    return crud.get_attendance_by_course(course_id=course_id, db=db)
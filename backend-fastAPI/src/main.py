from fastapi import FastAPI, Depends, HTTPException, UploadFile, File, Query, Body
from sqlalchemy.orm import Session
import models, schemas, crud, face_recognition_utils
from database import SessionLocal, engine
import json
from typing import Annotated

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


@app.get("/students/", response_model=list[schemas.Student])
async def get_students(skip: int=0, limit: int=100, db: Session = Depends(get_db)):
    return crud.get_students(db=db, skip=skip, limit=limit)


@app.post("/students/", response_model=schemas.Student)
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

@app.post("/courses", response_model=schemas.Course)
async def create_course(course: schemas.CourseCreate, db: Session=Depends(get_db)):
    return crud.create_course(db=db, course=course)

@app.post("/courses/student", response_model=schemas.Course)
async def add_student_to_course(course_id: int, students: Annotated[list[schemas.Student], Body()], db: Session=Depends(get_db)):
    print(students)
    print(course_id)
    db_course = crud.add_students_to_course(db=db, students=students, course_id=course_id)
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
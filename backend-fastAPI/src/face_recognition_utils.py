from retinaface import RetinaFace
from deepface import DeepFace
from deepface.modules import verification as vr
from PIL import Image
import schemas
import time
import numpy as np
import json


def generate_face_embedding(path):
    faces = RetinaFace.extract_faces(img_path = path, align = True)
    if not faces or len(faces) > 1:
        return None
    embedding = DeepFace.represent(path, model_name = 'Facenet512', align=True, detector_backend='retinaface', enforce_detection = True)
    return embedding[0]["embedding"]


def process_attendance_from_image(img_path: str, students: list[schemas.Student]):
    threshold = vr.find_threshold('Facenet512', 'euclidean_l2')
    faces = RetinaFace.extract_faces(img_path = img_path, align = True)
    present_students = []

    for face in faces:
        img = Image.fromarray(face)
        img.save('temp.jpg')
        min = float('inf')
        min_match_student = None
        start = time.time()
        embedding = np.array(DeepFace.represent('./temp.jpg', model_name = 'Facenet512', align=True, detector_backend='retinaface', enforce_detection = False))
        for student in students:
            source = vr.l2_normalize(json.loads(student.face_embedding))
            target = vr.l2_normalize(embedding[0]['embedding'])
            distance = vr.find_euclidean_distance(source, target)
            if distance <= threshold:
                if distance < min:
                    min = distance
                    min_match_student = student
        if not min_match_student:
            continue
        end = time.time()
        present_students.append(min_match_student)
        print('Recognised Student: {recognised_student} ({ID})'.format(recognised_student = min_match_student.name, ID=min_match_student.student_id))
        print('Euclidean distance: {dst}'.format(dst=min))
        print('Time taken in embedding and recognition: {time}'.format(time = end-start))
    
    print('Number of detected faces: {detected_faces}'.format(detected_faces=len(faces)))
    print('Number of recognized students: {recognized_num}'.format(recognized_num=len(present_students)))
    return present_students
from retinaface import RetinaFace
from deepface import DeepFace
from deepface.modules import verification as vr
from PIL import Image
import schemas
import time
import numpy as np
import json
import base64


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
        temp_matches = []
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
                temp_matches.append({
                    'student': student,
                    'distance': distance,
                })
                if distance < min:
                    min = distance
                    min_match_student = student
        if not min_match_student:
            continue
        

        if min_match_student in present_students:
            temp_min = float('inf')
            min_match_student = None
            for match in temp_matches:
                if match['student'] in present_students:
                    continue
                if match['distance'] < min:
                    min_match_student = match['student']
                    temp_min = match['distance']
                    min = temp_min
        if not min_match_student:
            continue

        end = time.time()
        
        
        with open("temp.jpg", "rb") as image_file:
            encoded_string = base64.b64encode(image_file.read())
        min_match_student.face = encoded_string
        present_students.append(min_match_student)
        print('Recognised Student: {recognised_student} ({ID})'.format(recognised_student = min_match_student.name, ID=min_match_student.student_id))
        print('Euclidean distance: {dst}'.format(dst=min))
        print('Time taken in embedding and recognition: {time}'.format(time = end-start))
    
    print('Number of detected faces: {detected_faces}'.format(detected_faces=len(faces)))
    print('Number of recognized students: {recognized_num}'.format(recognized_num=len(present_students)))
    return present_students
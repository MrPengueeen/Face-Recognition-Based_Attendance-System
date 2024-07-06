from retinaface import RetinaFace
from deepface import DeepFace


def generate_face_embedding(path):
    faces = RetinaFace.extract_faces(img_path = path, align = True)
    if not faces or len(faces) > 1:
        return None
    embedding = DeepFace.represent(path, model_name = 'Facenet', align=True, detector_backend='retinaface', enforce_detection = True)
    return embedding[0]["embedding"]
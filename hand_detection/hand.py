import mediapipe as mp
import cv2
import socket
import json

host = '127.0.0.1'
port = 5000

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((host, port))
server.listen()
print(f'Server is listening at {host}:{port}')

client, addr = server.accept()
print(f'New connection from {addr}')

cap=cv2.VideoCapture(0)

mp_drawing=mp.solutions.drawing_utils
mp_holistic=mp.solutions.holistic

holistic=mp_holistic.Holistic(min_tracking_confidence=0.65)

while True:
    ret,img=cap.read()
    img = cv2.flip(img, 1)
    image=cv2.cvtColor(img,cv2.COLOR_BGR2RGB)
    image.flags.writeable=False

    result=holistic.process(image)
    points = {}

    if not result.pose_landmarks:
        continue

    points['nose'] = {
        "x": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.NOSE].x,
        "y": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.NOSE].y
    }
    points["left_wrist"] = {
        "x": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.LEFT_THUMB].x,
        "y": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.LEFT_THUMB].y
    }
    points["right_wrist"] = {
        "x": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.RIGHT_THUMB].x,
        "y": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.RIGHT_THUMB].y
    }
    
    print(points)

    data_str = json.dumps(points) + "\n";
    client.send(data_str.encode());
    
    mp_drawing.draw_landmarks(img,result.pose_landmarks,mp_holistic.POSE_CONNECTIONS)
    cv2.imshow("Image", img)
    k = cv2.waitKey(30) & 0xff
    if k == 27: # press 'ESC' to quit
        break

cap.release()
cv2.destroyAllWindows()
client.close()
server.close()

import mediapipe as mp
import cv2
import socket
import json
from sound import play_sound

count = 0
# import threading


px, py, x, y = 0, 0, 0, 0

# t1 = threading.Thread(play_sound, args=(x, y, px, py))

host = '127.0.0.1'
port = 5000

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((host, port))
server.listen()
print(f'Server is listening at {host}:{port}')

client, addr = server.accept()
print(f'New connection from {addr}')

cap = cv2.VideoCapture(0)

mp_drawing = mp.solutions.drawing_utils
mp_holistic = mp.solutions.holistic

holistic = mp_holistic.Holistic(min_tracking_confidence=0.65)


def scale_image(img, factor=1):
    """Returns resize image by scale factor.
    This helps to retain resolution ratio while resizing.
    Args:
    img: image to be scaled
    factor: scale factor to resize
    """
    return cv2.resize(img, (int(img.shape[1]*factor), int(img.shape[0]*factor)))


while True:
    ret, img = cap.read()
    img = cv2.flip(img, 1)
    image = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    image.flags.writeable = False

    result = holistic.process(image)
    points = {}

    if not result.pose_landmarks:
        continue

    # points['nose'] = {
    #     "x": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.NOSE].x,
    #     "y": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.NOSE].y
    # }
    points["left_wrist"] = {
        "x": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.LEFT_THUMB].x,
        "y": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.LEFT_THUMB].y
    }
    points["right_wrist"] = {
        "x": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.RIGHT_THUMB].x,
        "y": result.pose_landmarks.landmark[mp_holistic.PoseLandmark.RIGHT_THUMB].y
    }

    # for key, val in points.items():
    #     if key == "left_wrist":
    #         x = val["x"]
    #         y = val["y"]
    #     elif key == "right_wrist":
    #         x = val["x"]
    #         y = val["y"]
    #     else:
    #         continue

    #     play_sound(x, y, px, py)

    # px, py = x, y

    x = points["right_wrist"]["x"]
    y = points["right_wrist"]["y"]

    if y < 1:
        play_sound(x, y, px, py)

    # t1.start()
    px, py = x, y

    # print(points)

    data_str = json.dumps(points) + "\n"
    client.send(data_str.encode())

    mp_drawing.draw_landmarks(
        img, result.pose_landmarks, mp_holistic.POSE_CONNECTIONS
    )

    img = scale_image(img, 0.5)

    cv2.imshow("Image", img)

    k = cv2.waitKey(30) & 0xff
    if k == 27:  # press 'ESC' to quit
        break

cap.release()
cv2.destroyAllWindows()
client.close()
server.close()

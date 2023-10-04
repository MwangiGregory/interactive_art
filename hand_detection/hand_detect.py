import mediapipe as mp
import cv2
from cvzone.HandTrackingModule import HandDetector

import socket
import pyautogui
import json


def map_value(in_v, in_min, in_max, out_min, out_max):
    """Helper method to map an input value (v_in)
       between alternative max/min ranges."""

    v = (in_v - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
    if v < out_min:
        v = out_min
    elif v > out_max:
        v = out_max

    return v


host = '127.0.0.1'
port = 5000
width, height = 640, 640

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((host, port))
server.listen()

client, addr = server.accept()
cap = cv2.VideoCapture(1)

# Increase maxHands to 6 to detect up to 6 hands
detector = HandDetector(detectionCon=0.8, maxHands=6)


while True:
    try:
        ret, frame = cap.read()
        print(frame.size)
        hands, img = detector.findHands(frame)

        if hands:
            for hand in hands:
                # Center of the current hand (cx, cy)
                centerPoint = hand["center"]
                cx, cy = centerPoint[0], centerPoint[1]
                mouseX = int(map_value(cx, 0, width, 0, 128))
                mouseY = int(map_value(cy, 0, height, 0, 128))
                hand_position = {"mouseX": mouseX, "mouseY": mouseY}

                print(hand_position)

                data_str = json.dumps(hand_position) + "\n"
                client.send(data_str.encode())
                break

        cv2.imshow('frame', frame)

        k = cv2.waitKey(30) & 0xff
        if k == 27:  # Press 'ESC' to quit
            break
    except KeyboardInterrupt:
        break


cap.release()
cv2.destroyAllWindows()
client.close()
server.close()

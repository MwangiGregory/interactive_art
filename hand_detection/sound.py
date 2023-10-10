from scamp import *
# import pyautogui

# screen_w, screen_h = pyautogui.size()
# prev_x, prev_y = pyautogui.position()


def map_value(in_v, in_min, in_max, out_min, out_max, flip_range=False):
    """Helper method to map an input value (v_in)
       between alternative max/min ranges."""

    v = (in_v - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
    # if v < out_min:
    #     v = out_min
    # elif v > out_max:
    #     v = out_max

    return v


s = s = Session()
cello = s.new_part("violin")


def play_sound(x, y, px, py):

    if x == px and y == py:
        return

    volume = x
    pitch = int(map_value(y, 0, 1, 70, 52))

    cello.play_note(pitch, volume, 0.1)


# while True:

#     x, y = pyautogui.position()

#     if x == prev_x and y == prev_y:
#         continue

#     vol = map_value(x, 0, screen_w, 0.2, 0.9)
#     pitch = int(map_value(y, 0, screen_h, 65, 52))
#     print(vol, pitch)

#     cello.play_note(pitch, vol, 0.25)

#     prev_x, prev_y = x, y

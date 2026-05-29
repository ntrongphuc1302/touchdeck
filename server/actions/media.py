import keyboard

def handle(action):
    if action == "media_play_pause":
        keyboard.send("play/pause media")

    elif action == "volume_up":
        keyboard.send("volume up")

    elif action == "volume_down":
        keyboard.send("volume down")
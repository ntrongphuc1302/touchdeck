import keyboard

ACTION_MAP = {
    "media_play_pause": "play/pause media",
    "volume_down": "volume down",
    "volume_up": "volume up",
}

def handle(action):
    key = ACTION_MAP.get(action)
    if key:
        keyboard.send(key)
import keyboard

def handle(action):

    if action == "discord_mute":
        keyboard.send("ctrl+alt+shift+m")
import asyncio
import json
import keyboard
import websockets

HOST = "0.0.0.0"
PORT = 8765

async def handler(websocket):
    print("Client connected")

    try:
        async for message in websocket:
            print("RAW:", message)

            data = json.loads(message)

            action = data.get("action")

            if action == "media_play_pause":
                keyboard.send("play/pause media")

            elif action == "volume_up":
                keyboard.send("volume up")

            elif action == "volume_down":
                keyboard.send("volume down")

            elif action == "discord_mute":
                keyboard.send("ctrl+shift+m")

            print("Executed:", action)

    except websockets.ConnectionClosed:
        print("Client disconnected")

    except Exception as e:
        print("Error:", e)

async def main():
    server = await websockets.serve(handler, HOST, PORT)

    print("TouchDeck server running")
    print(f"ws://localhost:{PORT}")

    await server.wait_closed()

asyncio.run(main())
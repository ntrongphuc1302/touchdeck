import asyncio
import json
import websockets

from actions import media
from actions import discord

HOST = "0.0.0.0"
PORT = 8765

async def handler(websocket):
    print("Client connected")

    try:
        async for message in websocket:
            data = json.loads(message)

            action = data.get("action")

            media.handle(action)
            discord.handle(action)

            print("Executed:", action)

    except websockets.ConnectionClosed:
        print("Client disconnected")

async def main():
    server = await websockets.serve(handler, HOST, PORT)

    print("TouchDeck server running")
    print(f"ws://localhost:{PORT}")

    await server.wait_closed()

asyncio.run(main())
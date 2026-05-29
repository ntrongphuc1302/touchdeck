import socket
import json
import time

BROADCAST_IP = "255.255.255.255"
PORT = 9999

MESSAGE = {
    "app": "TouchDeck",
    "device_name": "Zenith-PC",
    "ws_port": 8765
}

def start_broadcast():
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

    while True:
        data = json.dumps(MESSAGE).encode("utf-8")

        sock.sendto(data, (BROADCAST_IP, PORT))

        print("Broadcasted discovery packet")

        time.sleep(3)
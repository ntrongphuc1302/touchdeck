import socket
import json
import time

UDP_PORT = 9999
WS_PORT = 8765

MESSAGE = {
    "app": "TouchDeck",
    "device_name": "Zenith-PC",
    "ws_port": WS_PORT
}


def get_broadcast_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    finally:
        s.close()
    return ".".join(ip.split(".")[:-1]) + ".255"


def start_broadcast():
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    broadcast_ip = get_broadcast_ip()

    print(f"[Discovery] Broadcasting on {broadcast_ip}:{UDP_PORT}")

    while True:
        try:
            data = json.dumps(MESSAGE).encode("utf-8")
            sock.sendto(data, (broadcast_ip, UDP_PORT))
            print("Broadcasted discovery packet")
            time.sleep(2)
        except Exception as e:
            print("Broadcast error:", e)
            time.sleep(2)
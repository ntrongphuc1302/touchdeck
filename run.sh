#!/bin/bash

echo "=================================="
echo "       TOUCHDECK DEV MODE"
echo "=================================="

cd server

source venv/Scripts/activate

echo "[SERVER] Starting..."

python main.py &

SERVER_PID=$!

echo "[SERVER] PID: $SERVER_PID"

cd ../mobile

echo "[FLUTTER] Starting..."

flutter run

kill $SERVER_PID
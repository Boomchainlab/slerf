#!/bin/sh
echo "🔧 [Slerf@iSH] Bootstrap starting..."

# Step 1: Dependencies
echo "📦 Installing required packages..."
apk update && apk add --no-cache git python3 py3-pip nodejs npm curl

# Step 2: Clone repo (if not already inside)
if [ ! -d "slerf-earn-app" ]; then
  git clone https://github.com/Boomchainlab/slerf-earn-app.git
  cd slerf-earn-app || exit 1
else
  cd slerf-earn-app || exit 1
fi

# Step 3: Set up backend
if [ -d "backend" ]; then
  echo "🔁 Setting up Flask backend..."
  cd backend
  pip3 install -r requirements.txt
  echo "🚀 Launching Flask backend on http://localhost:8080"
  FLASK_APP=main.py FLASK_ENV=development flask run --host=0.0.0.0 --port=8080 &
  cd ..
else
  echo "⚠️ Backend folder missing, skipping..."
fi

# Step 4: Set up frontend
if [ -d "frontend" ]; then
  echo "🔁 Setting up frontend..."
  cd frontend
  npm install
  echo "🚀 Launching frontend (Vite) on http://localhost:5173"
  npm run dev -- --host
else
  echo "⚠️ Frontend folder missing, skipping..."
fi

echo "✅ [Slerf@iSH] Bootstrap complete."

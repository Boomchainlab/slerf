#!/bin/sh
echo "🔧 Slerf iSH Bootstrap Starting..."

# Step 1: Install dependencies
apk update && apk add git python3 py3-pip nodejs npm curl --no-cache

# Step 2: Clone the repo
cd ~
git clone https://github.com/Boomchainlab/slerf-earn-app.git
cd slerf-earn-app

# Step 3: Setup backend (Flask)
echo "📦 Installing backend Python dependencies..."
cd backend || exit 1
pip3 install -r requirements.txt

# Step 4: Run backend
echo "🚀 Launching Flask backend on http://localhost:8080"
FLASK_APP=main.py FLASK_ENV=development flask run --host=0.0.0.0 --port=8080 &

# Step 5: Setup frontend (if available)
cd ../frontend || exit 0  # If no frontend, just skip
echo "📦 Installing frontend dependencies..."
npm install

# Step 6: Run frontend
echo "🚀 Launching frontend (Vite) on http://localhost:5173"
npm run dev -- --host

# Done
echo "✅ Slerf iSH Dev Environment is Running"

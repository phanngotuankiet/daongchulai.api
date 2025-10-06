#!/bin/bash

echo "🚀 Starting Backend Server..."

# Kill any existing backend process
pkill -f "node server.js" || true

# Start backend server
cd /Users/theo/git2/daongchulai.api
node server.js

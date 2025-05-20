#!/bin/bash
# Script to install dependencies and run the TuteAI service with document upload feature

# Create directories
mkdir -p uploads

# Install dependencies
echo "Installing dependencies..."
uv pip install -r requirements.txt

# Run the service
echo "Starting TuteAI service..."
python main.py

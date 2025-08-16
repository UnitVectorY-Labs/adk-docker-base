# Always use the latest version of python 3 for base image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file first to leverage Docker cache
# This will install the latest version of "google-adk"
COPY requirements.txt .

# Install Python dependencies
# Use --no-cache-dir to reduce image size
RUN pip install --no-cache-dir -r requirements.txt

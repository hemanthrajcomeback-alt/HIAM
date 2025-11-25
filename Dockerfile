# Use Debian-based Python 3.9 image for better compatibility
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies needed for building wheels
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        python3-dev \
        libffi-dev \
        libssl-dev \
        build-essential \
        curl \
        git \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip, setuptools, wheel
RUN pip install --upgrade pip setuptools wheel

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code
COPY . .

# Set default command to run your bot/app
CMD ["python3", "-m", "Adarsh"]

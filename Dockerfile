# Use Python 3.11 slim for better compatibility
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install required system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        python3-dev \
        libssl-dev \
        libffi-dev \
        tzdata \
        curl \
        ntpdate \
    && rm -rf /var/lib/apt/lists/*

# Sync time immediately
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    ntpdate pool.ntp.org

# Copy requirements and install Python packages
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your bot code
COPY . .

# Set default command
CMD ["python3", "-m", "Adarsh"]

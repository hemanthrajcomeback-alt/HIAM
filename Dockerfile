# -------------------------------
# Stage 1: Build Stage
# -------------------------------
FROM python:3.11-slim AS builder

WORKDIR /app

# Prevent tzdata prompts
ARG DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        python3-dev \
        libssl-dev \
        libffi-dev \
        tzdata \
        curl \
    && ln -fs /usr/share/zoneinfo/Asia/Kolkata /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy requirements and install Python packages into /install
COPY requirements.txt .
RUN pip install --prefix=/install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . .

# -------------------------------
# Stage 2: Final Runtime Stage
# -------------------------------
FROM python:3.11-slim

WORKDIR /app

# Copy installed Python packages from builder
COPY --from=builder /install /usr/local

# Copy app code from builder
COPY --from=builder /app /app

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata curl && \
    ln -fs /usr/share/zoneinfo/Asia/Kolkata /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Default command
CMD ["python3", "-m", "Adarsh"]

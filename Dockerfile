# Use official Python runtime as base image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

RUN pip install --upgrade pip setuptools wheel

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
      curl \
      git \
      && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app4_time-distance.py .
COPY Config/ ./Config/
COPY Documentation/ ./Documentation/

# Expose default Streamlit port
EXPOSE 8501

# Health check
HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health || exit 1

# Set environment variables for Streamlit
ENV STREAMLIT_SERVER_HEADLESS=true
ENV STREAMLIT_SERVER_PORT=8501
ENV STREAMLIT_SERVER_ADDRESS=0.0.0.0

# Run the application
CMD ["streamlit", "run", "app4_time-distance.py"]

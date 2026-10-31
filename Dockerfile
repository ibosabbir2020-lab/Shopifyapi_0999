# Use official slim Python image
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Install system dependencies required by curl_cffi
# gcc/g++ compile the C extensions; libcurl4-openssl-dev provides SSL headers
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    make \
    libcurl4-openssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker layer caching
COPY requirements.txt .

# Install Python dependencies
# --no-cache-dir saves space in the final image
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose port 8080 (Render/Fly/Railway usually injects PORT env var, but 8080 is default fallback)
EXPOSE 8080

# START COMMAND
# Format: ["uvicorn", "module_name:app_variable", ...]
# Since your file is shopify.py and the app variable is 'app', we use "shopify:app"
CMD ["uvicorn", "shopify:app", "--host", "0.0.0.0", "--port", "8080"]
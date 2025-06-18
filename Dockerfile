# Base image
FROM python:3.11-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    chromium-driver \
    libnss3 \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libx11-xcb1 \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*


# Install Python libraries
RUN pip install --no-cache-dir \
    robotframework \
    robotframework-seleniumlibrary \
    selenium \
    pyyaml

# Set working directory
WORKDIR /testing

# Copy your test files (optional if you're building with local tests)
COPY . /testing

# Default command (can be overridden in docker run)
CMD ["robot", "--outputdir", "results", "tests/"]

FROM python:3.11-bullseye

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    gnupg \
    lsb-release \
    fonts-liberation \
    libappindicator3-1 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    libpango-1.0-0 \
    libvulkan1 \
    xdg-utils \
    libatspi2.0-0 \
    libcairo2 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxkbcommon0 \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome Stable
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# Install Robot Framework + Selenium 4.14.0+ (which includes Selenium Manager)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create working directory and copy your test files
WORKDIR /testing
COPY . /testing

# Ensure results directory exists
RUN mkdir -p /testing/results

# Set default browser for Robot tests
ENV ROBOT_BROWSER=chrome
ENV DISPLAY=:99

# Optional: Add non-root user (safer for CI environments)
# RUN useradd -ms /bin/bash robotuser
# USER robotuser

# Default command to run Robot tests
CMD ["robot", "--outputdir", "results", "tests/"]

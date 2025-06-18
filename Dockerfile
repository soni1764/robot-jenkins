# Use official lightweight Python image
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg2 fonts-liberation libnss3 libatk-bridge2.0-0 libxss1 libasound2 libgtk-3-0 libgbm1 libxshmfence1 xvfb \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome (stable version)
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Install ChromeDriver (compatible with Chrome 126)
ENV CHROMEDRIVER_VERSION=126.0.6478.114
RUN wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Install Python dependencies
RUN pip install --no-cache-dir robotframework selenium robotframework-seleniumlibrary

# Set working directory
WORKDIR /testing

# Copy project files into container
COPY . /testing

# Set environment variable for browser
ENV ROBOT_BROWSER=chrome

# Run tests and output results to /testing/results
CMD ["robot", "--outputdir", "results", "tests/"]

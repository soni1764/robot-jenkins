FROM python:3.11-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome (version 136.0.7103.113-1)
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Install ChromeDriver (version 136.0.7103.19)
RUN wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/136.0.7103.19/chromedriver_linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Install Robot Framework and SeleniumLibrary
RUN pip install --no-cache-dir robotframework selenium robotframework-seleniumlibrary

# Set working directory and copy project files
WORKDIR /testing
COPY . /testing

# Set environment variable for Robot Framework
ENV ROBOT_BROWSER=chrome

# Default command to run tests
CMD ["robot", "--outputdir", "results", "tests/"]

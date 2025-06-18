FROM python:3.11-slim

# Install Chrome
RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb

# Install ChromeDriver (compatible with Chrome version)
RUN CHROME_VERSION=$(google-chrome --version | grep -oP '\d+\.\d+\.\d+') && \
    DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION") && \
    wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/$DRIVER_VERSION/chromedriver_linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Install Robot Framework & SeleniumLibrary
RUN pip install --no-cache-dir robotframework selenium robotframework-seleniumlibrary

# Set working dir and copy project
WORKDIR /testing
COPY . /testing

# Set environment for robot
ENV ROBOT_BROWSER=chrome

# Default command
CMD ["robot", "--outputdir", "results", "tests/"]

FROM python:3.11-bullseye

# Install dependencies for Chrome and general utilities
RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg lsb-release fonts-liberation \
    libappindicator3-1 libatk-bridge2.0-0 libatk1.0-0 libcups2 \
    libdbus-1-3 libdrm2 libx11-6 libxcomposite1 libxdamage1 libxext6 \
    libxfixes3 libxrandr2 libxrender1 libxss1 libxtst6 libpango-1.0-0 \
    libvulkan1 xdg-utils libatspi2.0-0 libcairo2 libgtk-3-0 libnspr4 libnss3 \
    libxkbcommon0 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Google Chrome Stable
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update && apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# Install ChromeDriver matching installed Chrome version
RUN CHROME_VERSION=$(google-chrome --version | grep -oP '\d+\.\d+\.\d+') && \
    echo "Detected Chrome version: $CHROME_VERSION" && \
    CHROMEDRIVER_VERSION=$(curl -sS "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION") && \
    echo "Matching ChromeDriver version: $CHROMEDRIVER_VERSION" && \
    wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Install Robot Framework, SeleniumLibrary, and PyYAML
RUN pip install --no-cache-dir robotframework selenium robotframework-seleniumlibrary pyyaml

# Create working directory and copy your test files
WORKDIR /testing
COPY . /testing

# Create results directory so it exists before test run
RUN mkdir -p /testing/results

# Environment variable for Chrome options to run in Docker container smoothly
ENV ROBOT_BROWSER=chrome
ENV ROBOT_CHROME_OPTIONS="--headless --no-sandbox --disable-dev-shm-usage --disable-gpu --window-size=1920,1080"

# Default command to run Robot tests in /testing/tests/ folder, output to /testing/results
CMD ["robot", "--outputdir", "results", "--variable", "chrome_options:${ROBOT_CHROME_OPTIONS}", "tests/"]

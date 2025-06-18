FROM python:3.11-slim-bookworm

# Add contrib and non-free repos (if needed)
RUN sed -i 's/main/main contrib non-free/' /etc/apt/sources.list

# Update and install dependencies required by Chrome
RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg lsb-release \
    fonts-liberation libappindicator3-1 libatk-bridge2.0-0 libatk1.0-0 libcups2 \
    libdbus-1-3 libdrm2 libx11-6 libxcomposite1 libxdamage1 libxext6 libxfixes3 \
    libxrandr2 libxrender1 libxss1 libxtst6 libpango-1.0-0 libvulkan1 xdg-utils \
    libatspi2.0-0 libcairo2 libgtk-3-0 libnspr4 libnss3 libxkbcommon0 \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome stable
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Install ChromeDriver (match Chrome version)
RUN CHROME_DRIVER_VERSION=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE_136) && \
    wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Install Robot Framework and SeleniumLibrary
RUN pip install --no-cache-dir robotframework selenium robotframework-seleniumlibrary

# Create results directory
RUN mkdir -p /testing/results

WORKDIR /testing
COPY . /testing

ENV ROBOT_BROWSER=chrome

CMD ["robot", "--outputdir", "results", "tests/"]

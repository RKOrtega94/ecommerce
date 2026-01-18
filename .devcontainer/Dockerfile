FROM eclipse-temurin:25-jdk

# Install Node.js, npm, and Gradle
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Gradle
ENV GRADLE_VERSION=8.5
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle && \
    rm /tmp/gradle-${GRADLE_VERSION}-bin.zip

# Set working directory
WORKDIR /workspace

# Keep container running
CMD ["tail", "-f", "/dev/null"]


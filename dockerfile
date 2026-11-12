
# Stage 1: Build
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src
COPY testng.xml .
COPY webpage ./webpage

RUN mvn dependency:go-offline -B

RUN mvn test-compile

# Stage 2: Runtime
FROM maven:3.9.9-eclipse-temurin-17

WORKDIR /app

RUN apt-get update && apt-get install -y \
    chromium \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app /app

ENV CHROME_BIN=/usr/bin/chromium

CMD ["mvn", "test"]
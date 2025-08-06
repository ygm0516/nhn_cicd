# Base image with JDK 17 and Gradle 8.5
FROM docker.io/library/gradle:8.5-jdk17 AS builder

# Set the working directory
WORKDIR /app

# Copy the Gradle build files
COPY build.gradle settings.gradle /app/
COPY gradle /app/gradle

# Copy the source code
COPY src /app/src

# Build the application
RUN gradle build --no-daemon

# Use a smaller base image for the runtime
FROM docker.io/library/openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=builder /app/build/libs/*.jar /app/

# Command to run the JAR file
ENTRYPOINT ["java", "-jar", "/app/spring-music.jar"]


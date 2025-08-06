# -----------------------------------------------------------------------------
# Dockerfile for building and running a Spring Boot web application
#
# Build Stage:
#   - Uses Maven with OpenJDK 17 to build the application.
#   - Sets the working directory to /app.
#   - Copies the Maven project files (pom.xml and src directory) into the container.
#   - Runs 'mvn clean package' to build the application JAR, skipping tests.
#
# Run Stage:
#   - Uses a minimal Distroless OpenJDK 17 image for running the application.
#   - Sets the working directory to /app.
#   - Copies the built JAR from the build stage.
#   - Exposes port 8080 for the application.
#   - Sets the default command to run the Spring Boot application JAR.
# -----------------------------------------------------------------------------
# Build stage
FROM maven:3.9-eclipse-temurin-17-alpine AS build
# Set the working directory inside the container to /app
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM gcr.io/distroless/java17-debian11
WORKDIR /app
COPY --from=build /app/target/springboot-webapp-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
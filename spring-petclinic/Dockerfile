# Step 1: Use official lightweight Java image
FROM openjdk:17-jdk-slim

# Step 2: Set working directory inside the container
WORKDIR /app

# Step 3: Copy the built JAR file into the container
# (the jar will be created by Jenkins using Maven)
COPY target/*.jar app.jar

# Step 4: Expose the internal port your Spring Boot app runs on
EXPOSE 8080

# Step 5: Run the application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
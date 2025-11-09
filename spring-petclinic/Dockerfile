# Step 1: Use official lightweight JDK image
FROM eclipse-temurin:17-jdk-alpine

# Step 2: Set working directory inside container
WORKDIR /app

# Step 3: Copy Maven build files
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Step 4: Download dependencies (cached)
RUN ./mvnw dependency:go-offline

# Step 5: Copy full project
COPY src src

# Step 6: Package application
RUN ./mvnw clean package -DskipTests

# Step 7: Expose app port
EXPOSE 8081

# Step 8: Run the Spring Boot application
ENTRYPOINT [ "sh", "-c", "java", "-jar", "target/*.jar"]

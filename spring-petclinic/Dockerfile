# ==============================
# Stage 1: Build
# ==============================
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# Copy only what’s needed for Maven to cache dependencies
COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline

# Copy the source and build
COPY src src
RUN ./mvnw clean package -DskipTests

# ==============================
# Stage 2: Runtime
# ==============================
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy built JAR from build stage
COPY --from=build /app/target/spring-petclinic-*.jar app.jar

# Expose same port as Jenkinsfile
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

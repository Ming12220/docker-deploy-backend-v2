FROM maven:3.9-eclipse-temurin-21-alpine AS build-stage
WORKDIR /app
COPY pom.xml ./
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Production stage
FROM eclipse-temurin:21-jre-alpine AS production-stage
WORKDIR /app
COPY --from=build-stage /app/target/backend.jar ./app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]

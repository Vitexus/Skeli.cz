FROM eclipse-temurin:17-jre

ARG APP_DIR=/app
WORKDIR ${APP_DIR}

# Copy source and build with Maven wrapper if present; fallback to mvn in CI
# (For simplicity in this dev Dockerfile we just run the fat Jetty plugin)
COPY . .

EXPOSE 8080
CMD ["bash", "-lc", "mvn -q -DskipTests org.eclipse.jetty:jetty-maven-plugin:11.0.15:run"]

# First stage: build the application
FROM maven:3.8.7

# Set the working directory inside the container
WORKDIR /app

# Copy only the JAR file from the builder stage
COPY ./target/words.jar .

# Copy the PostgreSQL driver dependency
COPY ./target/dependency/postgresql-42.4.3.jar .

# Copy the Guava driver dependency
COPY ./target/dependency/guava-32.0.1-jre.jar .

# Expose the application port
EXPOSE 8080

# Define the command to start the application
CMD ["java", "-cp", ".:words.jar:guava-32.0.1-jre.jar:postgresql-42.4.3.jar", "Main"]

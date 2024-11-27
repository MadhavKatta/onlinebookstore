# Use an official Java runtime as a base image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the WAR file from Jenkins workspace to the container's working directory
COPY ./onlinebookstore.war /app/onlinebookstore.war

# Expose the port the app will run on
EXPOSE 8080

# Run the WAR file using the 'java' command
CMD ["java", "-jar", "/app/onlinebookstore.war"]

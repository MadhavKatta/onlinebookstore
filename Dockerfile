# Use the official Tomcat image from Docker Hub
FROM tomcat:9.0-jdk11-openjdk

# Copy the WAR file from the local system (relative to the build context)
# COPY onlinebookstore.war /usr/local/tomcat/webapps/onlinebookstore.war

COPY target/onlinebookstore.war /usr/local/tomcat/webapps/onlinebookstore.war


# Expose the Tomcat port (default 8080)
EXPOSE 8080

# Start Tomcat when the container runs
CMD ["catalina.sh", "run"]

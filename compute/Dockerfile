# Use an official Node.js runtime as the base image
FROM node:latest

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY . /app

# Install application dependencies
RUN npm i

# Expose a port for the application to listen on
EXPOSE 8080

# Define the command to start your application
CMD [ "node", "index.js" ]
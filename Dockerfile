# Start with a base image
FROM ubuntu:20.04

# Create a non-root user with a specific user ID
RUN useradd -u 1000 -m myuser

# Set a password for the non-root user
RUN echo "myuser:mypassword" | chpasswd

# Add the non-root user to the sudo group
RUN usermod -aG sudo myuser

# Set the working directory for subsequent commands
WORKDIR /home/myuser

# Set the user for subsequent commands
USER 1000

# Run a command as the non-root user
CMD ["/bin/bash"]

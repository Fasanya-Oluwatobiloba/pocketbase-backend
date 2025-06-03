# Use a minimal base image
FROM alpine:latest

# Set working directory
WORKDIR /app

# Copy PocketBase binary and make it executable
COPY pocketbase ./pocketbase
RUN chmod +x ./pocketbase

# Create and copy your data folder (optional)
COPY pb_data ./pb_data

# Expose the port PocketBase will run on
EXPOSE 10000

# Start PocketBase server
CMD ["./pocketbase", "serve", "--http=0.0.0.0:10000", "--dir", "pb_data"]

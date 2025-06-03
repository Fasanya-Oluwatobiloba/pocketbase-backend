FROM alpine:3.18

# 1. Install dependencies
RUN apk add --no-cache curl

# 2. Configure directories with strict permissions
RUN mkdir -p /app/pb_data && \
    chown -R 1000:1000 /app && \
    chmod 700 /app/pb_data  # ← Added strict permissions

# 3. Copy binary
COPY --chown=1000:1000 ./pocketbase /app/pocketbase
RUN chmod +x /app/pocketbase

# 4. Environment configuration
ENV PB_DATA_DIR="/app/pb_data" \
    PORT="8080" \  # ← Force port 8080
    PB_BIND_ADDR="0.0.0.0:8080"  # ← Explicit binding

# 5. Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/api/health || exit 1

# 6. Runtime configuration
USER 1000
WORKDIR /app
EXPOSE 8080

# 7. Startup command (with explicit flags)
CMD ["/app/pocketbase", "serve", "--http=0.0.0.0:8080", "--dir=/app/pb_data"]
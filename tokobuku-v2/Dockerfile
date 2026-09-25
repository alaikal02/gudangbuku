# ==============================================================================
# Multi-Stage Dockerfile for Darussholah Tokobuku Cloud Deployment
# Optimized for Cloudflare Containers, Serverless Edge Runtimes, and Cloudflare D1
# ==============================================================================

# ------------------------------------------------------------------------------
# Stage 1: Builder Stage (Environment Preparation & Syntax Validation)
# ------------------------------------------------------------------------------
FROM python:3.11-alpine AS builder

WORKDIR /build

# Build Arguments for Cloudflare D1 Environment Configuration
ARG PORT=8000
ARG CLOUDFLARE_ACCOUNT_ID=""
ARG CLOUDFLARE_D1_DATABASE_ID=""
ARG CLOUDFLARE_API_TOKEN=""

# Copy Application Source Files
COPY . /build/

# Validate Python Syntax and Precompile Bytecode for Instant Cold Start
RUN python3 -m py_compile server.py

# ------------------------------------------------------------------------------
# Stage 2: Final Minimal Serverless-Ready Stage (< 55MB Image)
# ------------------------------------------------------------------------------
FROM python:3.11-alpine AS runner

LABEL maintainer="Darussholah Publisher & Technology Team <dev@darussholah.id>"
LABEL description="Production Cloudflare D1 Container for Tokobuku Darussholah"

# Build Arguments Passed from Cloudflare Build Pipeline
ARG PORT=8000
ARG CLOUDFLARE_ACCOUNT_ID=""
ARG CLOUDFLARE_D1_DATABASE_ID=""
ARG CLOUDFLARE_API_TOKEN=""

# Runtime Environment Variables (Injected via Cloudflare Pages / Workers / Docker)
ENV PORT=${PORT} \
    HOST=0.0.0.0 \
    CLOUDFLARE_ACCOUNT_ID=${CLOUDFLARE_ACCOUNT_ID} \
    CLOUDFLARE_D1_DATABASE_ID=${CLOUDFLARE_D1_DATABASE_ID} \
    CLOUDFLARE_API_TOKEN=${CLOUDFLARE_API_TOKEN} \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    APP_HOME=/app

WORKDIR ${APP_HOME}

# Security Hardening: Create Non-Root User & Group
RUN addgroup -g 10001 -S appgroup && \
    adduser -u 10001 -S appuser -G appgroup

# Copy Clean Production Artifacts from Builder
COPY --from=builder /build ${APP_HOME}

# Ensure Uploads Directory Exists with Permissions
RUN mkdir -p ${APP_HOME}/uploads && \
    chown -R appuser:appgroup ${APP_HOME}

# Switch to Unprivileged Non-Root User
USER appuser

# Expose Application Port
EXPOSE ${PORT}

# Cloud Container Healthcheck Endpoint
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:${PORT:-8000}/api/health || exit 1

# Start Serverless-Ready Python Server
CMD ["sh", "-c", "python3 server.py ${PORT:-8000}"]

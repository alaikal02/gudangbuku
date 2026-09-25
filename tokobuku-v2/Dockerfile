# ==============================================================================
# Multi-Stage Dockerfile for Darussholah Tokobuku Cloud Deployment
# Optimized for Cloudflare Containers, Serverless Runtimes, and Docker Engine
# ==============================================================================

# ------------------------------------------------------------------------------
# Stage 1: Builder Stage (Environment Preparation & Asset Integrity Check)
# ------------------------------------------------------------------------------
FROM python:3.11-alpine AS builder

WORKDIR /build

# Build Arguments for Flexible Environment Configuration
ARG PORT=8000
ARG SUPABASE_URL=""
ARG SUPABASE_KEY=""

# Copy Application Source Files
COPY . /build/

# Validate Python Syntax and Precompile Bytecode for Speed
RUN python3 -m py_compile server.py

# ------------------------------------------------------------------------------
# Stage 2: Final Minimal Runner Stage (< 55MB Lightweight Image)
# ------------------------------------------------------------------------------
FROM python:3.11-alpine AS runner

LABEL maintainer="Darussholah Publisher & Technology Team <dev@darussholah.id>"
LABEL description="Production Cloud Container for Tokobuku Darussholah Web Platform"

# Build Arguments Passed from Build Pipeline
ARG PORT=8000
ARG SUPABASE_URL=""
ARG SUPABASE_KEY=""

# Runtime Environment Variables (Injected via Cloudflare / Docker Orchestrator)
ENV PORT=${PORT} \
    SUPABASE_URL=${SUPABASE_URL} \
    SUPABASE_KEY=${SUPABASE_KEY} \
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

# Start Production Python Server
CMD ["sh", "-c", "python3 server.py ${PORT:-8000}"]

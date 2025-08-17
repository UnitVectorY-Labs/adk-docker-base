# Always use the latest version of python 3 for base image
FROM python:3.12-slim

# Keep bytecode & cache out of layers
ENV PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_DEFAULT_TIMEOUT=120 \
    PIP_RETRIES=5

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file first to leverage Docker cache
# This will install the latest version of "google-adk"
COPY requirements.txt .

# Use pip cache mount (keeps cache out of the final image) +
# avoid writing .pyc, avoid caching wheels, prefer wheels over source.
RUN --mount=type=cache,target=/root/.cache/pip \
    python -m pip install -U pip && \
    python -m pip install --no-cache-dir --no-compile --prefer-binary \
      -r requirements.txt

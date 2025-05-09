# Define function directory
ARG FUNCTION_DIR="/function"

FROM python:alpine3.16@sha256:9efc6e155f287eb424ede74aeff198be75ae04504b1e42e87ec9f221e7410f2d AS python-alpine
RUN apk add --no-cache \
    libstdc++

FROM python-alpine as build-image

# Install aws-lambda-cpp build dependencies
RUN apk add --no-cache \
    build-base \
    libtool \
    autoconf \
    automake \
    libexecinfo-dev \
    make \
    cmake \
    libcurl

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Copy function code
COPY src/test_main.py ${FUNCTION_DIR}
COPY src/main.py ${FUNCTION_DIR}

COPY src/requirements_dev.txt requirements.txt

# Install the runtime interface client
RUN python -m pip install --upgrade pip
RUN python -m pip install \
        --target ${FUNCTION_DIR} \
        --requirement requirements.txt

# Multi-stage build: grab a fresh copy of the base image
FROM python-alpine

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the build image dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD ["main.handler"]

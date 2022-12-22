# Define function directory
ARG FUNCTION_DIR="/function"

FROM public.ecr.aws/docker/library/python:buster as build-image

# Install aws-lambda-cpp build dependencies
RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Copy function code
COPY lambda/clsf-to-sqs/src/main.py ${FUNCTION_DIR}

COPY lambda/clsf-to-sqs/src/requirements.txt requirements.txt

# Install the runtime interface client
RUN python -m pip install --upgrade pip
RUN python -m pip install \
    --target ${FUNCTION_DIR} \
    --requirement requirements.txt

# Multi-stage build: grab a fresh copy of the base image
FROM public.ecr.aws/docker/library/python:buster

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the build image dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD ["main.handler"]

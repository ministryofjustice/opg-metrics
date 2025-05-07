# Define function directory
ARG FUNCTION_DIR="/function"

FROM python:3.12 AS build-image
# FROM python:3.13.3-alpine3.21 AS build-image
# RUN apk add --no-cache \
#     libstdc++

# FROM python-alpine AS build-image

# Install aws-lambda-cpp build dependencies
# RUN apk add --no-cache \
#     cmake
    # libcurl \
    # build-base \
    # libtool \
    # autoconf \
    # automake \
    # libexecinfo-dev \
    # make

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Copy function code
COPY lambda/clsf-to-sqs/src/main.py ${FUNCTION_DIR}

COPY lambda/clsf-to-sqs/src/requirements.txt ${FUNCTION_DIR}/requirements.txt

# Install the runtime interface client
RUN pip install --no-cache-dir --upgrade pip==25.1.1 && \
  pip install --no-cache-dir \
    --target ${FUNCTION_DIR} \
    --requirement ${FUNCTION_DIR}/requirements.txt

# Use a slim version of the base Python image to reduce the final image size
FROM scratch

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the build image dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD ["main.handler"]

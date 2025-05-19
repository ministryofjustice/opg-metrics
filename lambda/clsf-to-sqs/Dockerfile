# Define function directory
ARG FUNCTION_DIR="/function"

FROM python:alpine AS base
RUN apk -U --no-cache upgrade && \
  apk add --no-cache \
  libstdc++ \
  zstd-libs

FROM base AS build-image

# Install aws-lambda-cpp build dependencies
RUN apk add --no-cache \
  autoconf \
  automake \
  build-base \
  cmake \
  elfutils-dev \
  libcurl \
  libtool \
  make


FROM build-image AS prod-build
# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Copy function code
COPY lambda/clsf-to-sqs/src/main.py ${FUNCTION_DIR}

COPY lambda/clsf-to-sqs/src/requirements.txt ${FUNCTION_DIR}/requirements.txt

# Install the runtime interface client
RUN python -m pip install --no-cache-dir --upgrade pip && \
  python -m pip install --no-cache-dir \
  --target ${FUNCTION_DIR} \
  --requirement ${FUNCTION_DIR}/requirements.txt

FROM build-image AS test-build
# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Copy function code
COPY lambda/clsf-to-sqs/src/test_main.py ${FUNCTION_DIR}
COPY lambda/clsf-to-sqs/src/main.py ${FUNCTION_DIR}

COPY lambda/clsf-to-sqs/src/requirements_dev.txt /${FUNCTION_DIR}requirements.txt

# Install the runtime interface client
RUN python -m pip install --no-cache-dir --upgrade pip && \
  python -m pip install --no-cache-dir \
  --target ${FUNCTION_DIR} \
  --requirement ${FUNCTION_DIR}/requirements.txt

# Multi-stage build: grab a fresh copy of the base image
FROM base AS production

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the build image dependencies
COPY --from=prod-build ${FUNCTION_DIR} ${FUNCTION_DIR}

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD ["main.handler"]

FROM base AS test

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the build image dependencies
COPY --from=test-build ${FUNCTION_DIR} ${FUNCTION_DIR}

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD ["main.handler"]

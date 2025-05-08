# Define function directory
ARG FUNCTION_DIR="/function"

FROM python:3.12 AS build-image

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Copy function code
COPY lambda/clsf-to-sqs/src/test_main.py ${FUNCTION_DIR}
COPY lambda/clsf-to-sqs/src/main.py ${FUNCTION_DIR}

COPY lambda/clsf-to-sqs/src/requirements_dev.txt /${FUNCTION_DIR}requirements.txt

# Install the runtime interface client
RUN python -m pip install --no-cache-dir --upgrade pip==25.1.1 && \
  python -m pip install --no-cache-dir \
  --target ${FUNCTION_DIR} \
  --requirement ${FUNCTION_DIR}/requirements.txt

# Multi-stage build: grab a fresh copy of the base image
FROM python:3.12-slim

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the build image dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD ["main.handler"]

FROM public.ecr.aws/lambda/python:3.8

WORKDIR /var/task
COPY lambda/clsf-to-sqs/src/main.py ./
CMD ["main.handler"]

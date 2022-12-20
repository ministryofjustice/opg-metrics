FROM public.ecr.aws/lambda/python:3.9.2022.12.14.07

WORKDIR /var/task
COPY lambda/clsf-to-sqs/src/main.py ./
CMD ["main.handler"]

FROM public.ecr.aws/lambda/python:3.9.2022.12.14.07

RUN pip install requests requests_aws4auth

WORKDIR /var/task
COPY . ./
CMD ["main.handler"]

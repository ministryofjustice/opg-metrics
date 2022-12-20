FROM public.ecr.aws/lambda/python:3.9.2022.12.14.07

WORKDIR /var/task

COPY lambda/ship-to-opg-metrics/src/requirements.txt ./
COPY lambda/ship-to-opg-metrics/src/main.py ./
RUN pip install --no-cache-dir -r ./requirements.txt

CMD ["main.handler"]

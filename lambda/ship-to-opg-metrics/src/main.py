import os
import ast
import logging
import requests
import boto3
from aws_xray_sdk.core import patch_all, xray_recorder

logger = logging.getLogger()
logger.setLevel(logging.INFO)
xray_recorder.begin_segment('opg_metrics')
patch_all()


def handler(event, context):
    xray_recorder.begin_subsegment('ship_to_metrics')
    for message in event['Records']:
        records = ast.literal_eval(message["body"])
        logger.info("processing record: %s", records)

        call_api_gateway(records)
    xray_recorder.end_subsegment()
    return records


def get_api_key(secret_arn):
    client = boto3.client('secretsmanager')
    api_key = client.get_secret_value(
        SecretId=secret_arn
    )

    return api_key["SecretString"]


def call_api_gateway(json_data):
    url = os.getenv('OPG_METRICS_URL')
    secret_arn = os.getenv('SECRET_ARN')
    api_key = get_api_key(secret_arn)
    method = 'PUT'
    path = '/metrics'
    headers = {
        'Content-Type': 'application/json',
        'Content-Length': str(len(str(json_data))),
        'x-api-key': api_key
    }

    response = requests.request(
        method=method,
        url=url+path,
        json=json_data,
        headers=headers
    )
    logger.info(response.json())

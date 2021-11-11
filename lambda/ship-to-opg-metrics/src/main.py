import os
import requests
import ast
import boto3


def handler(event, context):
    for message in event['Records']:
        records = ast.literal_eval(message["body"])
        print(records)

        call_api_gateway(records)

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
    print(response.json())

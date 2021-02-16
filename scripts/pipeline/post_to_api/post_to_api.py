import boto3
import argparse
import json
from requests import auth
from requests_aws4auth import AWS4Auth
import requests
import os


class APIGatewayCaller:
    aws_account_id = ''
    api_gateway_url = ''
    aws_iam_session = ''
    aws_auth = ''

    def __init__(self, target_production):
        self.choose_target_gateway(target_production)
        self.set_iam_role_session()
        self.api_gateway_stage = os.getenv('TF_WORKSPACE', "development")
        self.aws_auth = AWS4Auth(
            self.aws_iam_session['Credentials']['AccessKeyId'],
            self.aws_iam_session['Credentials']['SecretAccessKey'],
            'eu-west-1',
            'execute-api',
            session_token=self.aws_iam_session['Credentials']['SessionToken'])

    def choose_target_gateway(self, target_production):
        if target_production:
            self.aws_account_id = '679638075911'
        else:
            self.aws_account_id = '679638075911'

    def set_iam_role_session(self):
        if os.getenv('CI'):
            role_arn = 'arn:aws:iam::{}:role/ci'.format(self.aws_account_id)
        else:
            role_arn = 'arn:aws:iam::{0}:role/operator'.format(
                self.aws_account_id)

        sts = boto3.client(
            'sts',
            region_name='eu-west-1',
        )
        session = sts.assume_role(
            RoleArn=role_arn,
            RoleSessionName='calling_api_gateway',
            DurationSeconds=900
        )
        self.aws_iam_session = session

    def call_api_gateway(self, json_data, url):
        method = 'PUT'
        data = str(json_data)
        path = '/{}/metrics'.format(self.api_gateway_stage)
        headers = {
          'Content-Type': 'application/json',
          'Content-Length': str(len(data)),
          }
        response = requests.request(
            method=method, url=url+path, auth=self.aws_auth, json=data, headers=headers)
        print(response.text)


def main():
    parser = argparse.ArgumentParser(
        description="Make a PUT request to OPG Metrics")

    parser.add_argument("--json_file", type=str,
                        help="Relative path to json file containing metrics data to be pushed")
    parser.add_argument("--url", type=str,
                        help="API URL to use")
    parser.add_argument('--production', dest='target_production', action='store_const',
                        const=True, default=False,
                        help='target the production api gateway')

    args = parser.parse_args()
    work = APIGatewayCaller(args.target_production)


    with open(args.json_file) as json_file:
        json_data = json.load(json_file)
        # print(json.dumps(json_data, indent = 4))
        work.call_api_gateway(json_data, args.url)


if __name__ == "__main__":
    main()

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_api_key.trusted_services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_api_key) | resource |
| [aws_api_gateway_usage_plan.trusted_services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan) | resource |
| [aws_api_gateway_usage_plan_key.trusted_services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan_key) | resource |
| [aws_secretsmanager_secret.api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_policy.api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_version.api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_iam_policy_document.api_key_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_api_gateway_rest_api"></a> [aws\_api\_gateway\_rest\_api](#input\_aws\_api\_gateway\_rest\_api) | API Id of the associated API stage in a usage plan. | `string` | n/a | yes |
| <a name="input_aws_api_gateway_stage"></a> [aws\_api\_gateway\_stage](#input\_aws\_api\_gateway\_stage) | API stage name of the associated API stage in a usage plan. | `string` | n/a | yes |
| <a name="input_identifiers_arns"></a> [identifiers\_arns](#input\_identifiers\_arns) | List of identifiers for principals. | `list(string)` | n/a | yes |
| <a name="input_secret_recovery_window_in_days"></a> [secret\_recovery\_window\_in\_days](#input\_secret\_recovery\_window\_in\_days) | Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. | `number` | `7` | no |
| <a name="input_trusted_service_name"></a> [trusted\_service\_name](#input\_trusted\_service\_name) | Friendly name of the new secret. The secret name can consist of uppercase letters, lowercase letters, digits, and any of the following characters: /_+=.@- Conflicts with name_prefix. | `string` | n/a | yes |
| <a name="input_usage_plan_quota_settings_limit"></a> [usage\_plan\_quota\_settings\_limit](#input\_usage\_plan\_quota\_settings\_limit) | The maximum number of requests that can be made in a given time period. | `number` | `10000` | no |
| <a name="input_usage_plan_quota_settings_offset"></a> [usage\_plan\_quota\_settings\_offset](#input\_usage\_plan\_quota\_settings\_offset) | The number of requests subtracted from the given limit in the initial time period. | `number` | `2` | no |
| <a name="input_usage_plan_quota_settings_period"></a> [usage\_plan\_quota\_settings\_period](#input\_usage\_plan\_quota\_settings\_period) | The time period in which the limit applies. Valid values are "DAY", "WEEK" or "MONTH". | `string` | `"WEEK"` | no |
| <a name="input_usage_plan_throttle_settings_burst_limit"></a> [usage\_plan\_throttle\_settings\_burst\_limit](#input\_usage\_plan\_throttle\_settings\_burst\_limit) | The API request burst limit, the maximum rate limit over a time ranging from one to a few seconds, depending upon whether the underlying token bucket is at its full capacity. | `number` | `5` | no |
| <a name="input_usage_plan_throttle_settings_rate_limit"></a> [usage\_plan\_throttle\_settings\_rate\_limit](#input\_usage\_plan\_throttle\_settings\_rate\_limit) | The API request steady-state rate limit. | `number` | `10` | no |

## Outputs

No outputs.

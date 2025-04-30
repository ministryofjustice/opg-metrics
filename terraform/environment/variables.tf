variable "name" {
  default     = "opg-metrics"
  description = "The name of the service"
  type        = string
}

variable "environments" {
  type = map(
    object({
      account_id   = string
      account_name = string
    })
  )
}

locals {
  environment_name  = lower(replace(terraform.workspace, "_", "-"))
  environment       = contains(keys(var.environments), local.environment_name) ? var.environments[local.environment_name] : var.environments["default"]
  dns_namespace_env = local.environment_name == "production" ? "" : "${local.environment_name}."

  mandatory_moj_tags = {
    business-unit    = "OPG"
    application      = "opg-metrics"
    environment-name = local.environment_name
    owner            = "OPGOPS opgteam+opgmetrics@digital.justice.gov.uk"
    is-production    = "true"
    runbook          = "https://github.com/ministryofjustice/opg-metrics"
    source-code      = "https://github.com/ministryofjustice/opg-metrics"
  }

  default_tags = local.mandatory_moj_tags
}

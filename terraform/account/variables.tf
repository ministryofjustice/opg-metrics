variable "accounts" {
  type = map(
    object({
      account_id = string
    })
  )
}

locals {
  account_name = lower(replace(terraform.workspace, "_", "-"))
  account      = contains(keys(var.accounts), local.account_name) ? var.accounts[local.account_name] : var.accounts["default"]

  mandatory_moj_tags = {
    business-unit    = "OPG"
    application      = "opg-metrics-shared"
    environment-name = local.account_name
    owner            = "OPGOPS opgteam+opgmetrics@digital.justice.gov.uk"
    is-production    = "false"
    runbook          = "https://github.com/ministryofjustice/opg-metrics"
    source-code      = "https://github.com/ministryofjustice/opg-metrics"
  }

  tags = local.mandatory_moj_tags
}

locals {
  mandatory_moj_tags = {
    business-unit    = "OPG"
    application      = "opg-metrics-shared"
    environment-name = terraform.workspace
    owner            = "OPGOPS opgteam+opgmetrics@digital.justice.gov.uk"
    is-production    = "false"
    runbook          = "https://github.com/ministryofjustice/opg-metrics"
    source-code      = "https://github.com/ministryofjustice/opg-metrics"
  }

  tags = local.mandatory_moj_tags
}

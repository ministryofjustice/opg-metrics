variable "administrator_roles" {
  description = "List of Role ARNs allowed to administer the KMS Key"
  type        = list(string)
}

variable "alias" {
  description = "KMS Key Alias"
  type        = string
}

variable "decryption_roles" {
  description = "List of Role ARNs allowed to use the KMS Key for Decryption"
  type        = list(string)
}

variable "description" {
  description = "KMS Key Description"
  type        = string
}

variable "encryption_roles" {
  description = "List of Role ARNs allowed to use the KMS Key for Encryption"
  type        = list(string)
}

variable "usage_services" {
  description = "List of AWS Service that the usage roles can use the KMS "
  type        = list(string)
}

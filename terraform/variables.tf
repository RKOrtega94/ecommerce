# Variables for app and environment

variable "app_version" {
  description = "Application version (used for tagging images/env var)"
  type        = string
  default     = "1.0.0"
}

variable "environment" {
  description = "Deployment environment label (blue|green)"
  type        = string
  default     = "blue"
}

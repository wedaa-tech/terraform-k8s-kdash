variable "create_namespace" {
  description = "Create namespace by module ? true or false"
  type        = bool
  default     = true
}

variable "namespace" {
  description = "Namespace name"
  type        = string
  default     = "kubernetes-dashboard"
}

variable "create_admin_token" {
  description = "Create admin token for auth"
  type        = bool
  default     = true
}

variable "enable_skip_button" {
  description = "Skip login page for ready only access"
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "Helm Chart version (Not Recomended)"
  type        = string
  default     = "7.13.0"
}

# General configuration shared across resources
variable "app_mode" {
  description = "Mode determines if chart should deploy a full Dashboard with all containers or just the API."
  type        = string
  default     = "dashboard"
}

# Common labels & annotations shared across all deployed resources
variable "labels" {
  description = "Common labels to be added to all Dashboard resources"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Common annotations to be added to all Dashboard resources"
  type        = map(string)
  default     = {}
}

# Global dashboard settings
variable "dashboard_cluster_name" {
  description = "Cluster name that appears in the browser window title"
  type        = string
  default     = ""
}

variable "dashboard_items_per_page" {
  description = "Max number of items shown per list page"
  type        = number
  default     = 20
}

variable "dashboard_labels_limit" {
  description = "Max number of labels displayed by default"
  type        = number
  default     = 3
}

variable "dashboard_logs_auto_refresh_interval" {
  description = "Seconds between each logs auto-refresh"
  type        = number
  default     = 5
}

variable "dashboard_resource_auto_refresh_interval" {
  description = "Seconds between each resource auto-refresh (0 to disable)"
  type        = number
  default     = 10
}

variable "dashboard_disable_access_denied_notifications" {
  description = "Hide all access denied warnings in the notification panel"
  type        = bool
  default     = false
}

variable "dashboard_hide_all_namespaces" {
  description = "Hide the 'All Namespaces' option in namespace dropdown"
  type        = bool
  default     = false
}

variable "dashboard_default_namespace" {
  description = "Namespace selected by default after logging in"
  type        = string
  default     = "default"
}

variable "dashboard_namespace_fallback_list" {
  description = "List of fallback namespaces shown to users without list privileges"
  type        = list(string)
  default     = ["default"]
}
resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0

  metadata {
    annotations = {
      name = var.namespace
    }
    name = var.namespace
  }
}

locals {
  dashboard_chart      = "kubernetes-dashboard"
  dashboard_repository = "https://kubernetes.github.io/dashboard/"
}

resource "helm_release" "dashboard" {
  name            = local.dashboard_chart
  repository      = local.dashboard_repository
  chart           = local.dashboard_chart
  namespace       = var.create_namespace ? kubernetes_namespace.namespace[0].id : var.namespace
  cleanup_on_fail = true
  version         = var.chart_version

  # General configuration shared across resources
  set {
    name  = "app.mode"
    value = var.app_mode
  }

  # Common labels & annotations shared across all deployed resources
  dynamic "set" {
    for_each = var.labels
    content {
      name  = "app.labels.${set.key}"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.annotations
    content {
      name  = "app.annotations.${set.key}"
      value = set.value
    }
  }

  # Global dashboard settings
  set {
    name  = "app.settings.global.clusterName"
    value = var.dashboard_cluster_name
  }

  set {
    name  = "app.settings.global.itemsPerPage"
    value = var.dashboard_items_per_page
  }

  set {
    name  = "app.settings.global.labelsLimit"
    value = var.dashboard_labels_limit
  }

  set {
    name  = "app.settings.global.logsAutoRefreshTimeInterval"
    value = var.dashboard_logs_auto_refresh_interval
  }

  set {
    name  = "app.settings.global.resourceAutoRefreshTimeInterval"
    value = var.dashboard_resource_auto_refresh_interval
  }

  set {
    name  = "app.settings.global.disableAccessDeniedNotifications"
    value = var.dashboard_disable_access_denied_notifications
  }

  set {
    name  = "app.settings.global.hideAllNamespaces"
    value = var.dashboard_hide_all_namespaces
  }

  set {
    name  = "app.settings.global.defaultNamespace"
    value = var.dashboard_default_namespace
  }

  dynamic "set" {
    for_each = var.dashboard_namespace_fallback_list
    content {
      name  = "app.settings.global.namespaceFallbackList[${set.key}]"
      value = set.value
    }
  }

  # Skip login page for read-only access
  set {
    name  = "app.settings.global.skipLoginPage"
    value = var.enable_skip_button
  }
}

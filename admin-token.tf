# =====================================================
# Admin Token Resources
# Creates a service account with cluster-admin privileges
# for full dashboard access
# =====================================================

locals {
  dashboard_admin_service_account = "kdash-admin"
}

resource "kubernetes_service_account_v1" "admin_service_account" {
  count = var.create_admin_token ? 1 : 0

  metadata {
    name      = local.dashboard_admin_service_account
    namespace = var.create_namespace ? kubernetes_namespace.namespace[0].id : var.namespace
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "admin_role_binding" {
  count = var.create_admin_token ? 1 : 0

  depends_on = [helm_release.dashboard]

  metadata {
    name = local.dashboard_admin_service_account
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.admin_service_account[0].metadata[0].name
    namespace = var.create_namespace ? kubernetes_namespace.namespace[0].id : var.namespace
  }
}

resource "kubernetes_secret_v1" "admin_token" {
  count = var.create_admin_token ? 1 : 0

  metadata {
    annotations = {
      "kubernetes.io/service-account.name"      = kubernetes_service_account_v1.admin_service_account[0].metadata[0].name
      "kubernetes.io/service-account.namespace" = var.create_namespace ? kubernetes_namespace.namespace[0].id : var.namespace
    }
    name      = "${kubernetes_service_account_v1.admin_service_account[0].metadata[0].name}-token"
    namespace = var.create_namespace ? kubernetes_namespace.namespace[0].id : var.namespace
  }

  type = "kubernetes.io/service-account-token"
}


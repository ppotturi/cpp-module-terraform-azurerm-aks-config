# Install istio operator using the chart.
# Need to update below to pull the chart from private acr.
resource "helm_release" "istio_operator_install" {
  name    = "istio-operator"
  chart   = "${path.module}/charts/istio-${var.istio_version}/istio-operator"
  version = var.istio_version

  set {
    name  = "operatorNamespace"
    value = "istio-operator"
  }
}

resource "kubernetes_namespace" "istio_namespace" {
  metadata {
    name = "istio-system"
  }
}

# Apply IstioOperator manifest to the operator 
resource "kubectl_manifest" "istio_operator_manifest" {
  yaml_body = templatefile("${path.module}/manifests/istio.yaml", {
    istio_node_selector                        = var.istio_node_selector_label
    istio_ingress_load_balancer_resource_group = var.istio_ingress_load_balancer_resource_group
    systempool_taint_key                       = var.systempool_taint_key
  })

  depends_on = [
    helm_release.istio_operator_install,
    kubernetes_namespace.istio_namespace
  ]
}
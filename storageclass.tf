resource "kubectl_manifest" "custom_storageclass_alfresco" {
  yaml_body          = <<YAML
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: azurefile-csi-alfresco-retain
provisioner: file.csi.azure.com
allowVolumeExpansion: true
mountOptions:
  - dir_mode=0777
  - file_mode=0777
  - uid=0
  - gid=0
  - mfsymlinks
  - cache=strict
  - actimeo=30
parameters:
  skuName: Standard_LRS
reclaimPolicy: Retain
YAML
}
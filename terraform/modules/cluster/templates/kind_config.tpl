kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: ${disableDefaultCNI}
nodes:%{ for node in range(controlNodes) }
- role: control-plane%{ endfor ~}%{ for worker in range(workerNodes) }
- role: worker%{ endfor ~}

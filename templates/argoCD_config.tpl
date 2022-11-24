server:
  ingress:
    enabled: ${ingress}
    annotations:
      kubernetes.io/ingress.class: nginx
    hosts:
    - argo-cd.127.0.0.1.nip.io
configs:
  params:
    server.insecure: true
  repositories:
    ${indent(4, repositories)}

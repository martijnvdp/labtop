USER-SUPPLIED VALUES:
externalIPs:
  enabled: true
hostPort:
  enabled: true
hostServices:
  enabled: false
  protocols: "tcp"
hubble:
  enabled: true
  relay:
    enabled: true
  ui:
    enabled: true
    ingress:%{ if ingress }
      annotations:
        kubernetes.io/ingress.class: nginx
      enabled: true
      hosts:
      - hubble-ui.127.0.0.1.nip.io%{ endif }
ipamMode: kubernetes
k8sServiceHost: labtop-control-plane
k8sServicePort: 6443
kubeProxyReplacement: strict
nodePort:
  enabled: true

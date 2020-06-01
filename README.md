# openssh-server, mosh-server, and kubectl in a Docker container

- This is not useful to anyone but me, probably
- But if you like, here's what it is:
    - alpine-based docker image containing openssh-server, mosh, and kubectl
    - Useful as an SSH entrypoint into a k8s cluster
    - Heavily limited permissions for the serviceaccount, see `deploy/clusterrole.yaml`
    - LoadBalancer services for openssh and mosh, see `deploy/services.yaml`

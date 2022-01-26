# https://zero-to-jupyterhub.readthedocs.io/en/latest/jupyterhub/installation.html#initialize-a-helm-chart-configuration-file

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

helm upgrade --cleanup-on-fail \
  --install my-jupyterhub jupyterhub/jupyterhub \
  --namespace jupyterhub\
  --create-namespace \
  --version=1.2.0 \
  --values helm-jupyterhub-values.yaml

kubectl -n jupyterhub get svc proxy-public -o jsonpath='{.status.loadBalancer.ingress[].ip}'

kubectl --namespace=jupyterhub get svc proxy-public


# (⎈ |kind-multi:jupyter)~/gh/halcyondude/devenv/jupyterhub (main ✘)✹✭ ᐅ helm upgrade --cleanup-on-fail \
#   --install my-jupyterhub jupyterhub/jupyterhub \
#   --namespace jupyterhub\
#   --create-namespace \
#   --version=1.2.0 \
#   --values helm-jupyterhub-values.yaml
# Release "my-jupyterhub" does not exist. Installing it now.
# NAME: my-jupyterhub
# LAST DEPLOYED: Thu Jan 20 23:33:02 2022
# NAMESPACE: jupyterhub
# STATUS: deployed
# REVISION: 1
# TEST SUITE: None
# NOTES:
# Thank you for installing JupyterHub!

# Your release is named "my-jupyterhub" and installed into the namespace "jupyterhub".

# You can check whether the hub and proxy are ready by running:

#  kubectl --namespace=jupyterhub get pod

# and watching for both those pods to be in status 'Running'.

# You can find the public (load-balancer) IP of JupyterHub by running:

#   kubectl -n jupyterhub get svc proxy-public -o jsonpath='{.status.loadBalancer.ingress[].ip}'

# It might take a few minutes for it to appear!

# To get full information about the JupyterHub proxy service run:

#   kubectl --namespace=jupyterhub get svc proxy-public

# If you have questions, please:

#   1. Read the guide at https://z2jh.jupyter.org
#   2. Ask for help or chat to us on https://discourse.jupyter.org/
#   3. If you find a bug please report it at https://github.com/jupyterhub/zero-to-jupyterhub-k8s/issues
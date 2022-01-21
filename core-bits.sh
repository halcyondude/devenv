set -x

#
# Create a Kind Cluster, and install CP to it.
#
# More Info --> https://kind.sigs.k8s.io/docs/user/configuration
#
kind create cluster --name my-dev-multinode --config kind-multi-node.yaml

### begin nginx ingress

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl apply -f nginx-ingress-kindpatches.yaml

# wait until ingress is ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

# deploy 2 services (foo, bar) that echo, and confirm it works
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml

# should output "foo"
curl localhost/foo

# should output "bar"
curl localhost/bar
### end nginx


# install crossplane
kubectl create namespace crossplane-system

helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane --namespace crossplane-system crossplane-stable/crossplane

# install bifocals, so we can browse CRDs
kubectl create namespace bifocals
kubectl -n bifocals apply -f https://raw.githubusercontent.com/crdsdev/bifocals/master/deploy/manifests/install.yaml

# (hack) expose dashboard
kubectl port-forward svc/bifocals -n bifocals 8080:80

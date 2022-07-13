#!/usr/bin/env bash

read -r -d '' KREW_INTRO_MSG << EndOfKrewIntroMessage
What is krew?

Homepage: https://krew.sigs.k8s.io

Krew is the plugin manager for kubectl command-line tool.

Krew helps you:

* discover kubectl plugins,
* install them on your machine,
* keep the installed plugins up-to-date.

There are 196 kubectl plugins currently distributed on Krew.

Krew works across all major platforms, like macOS, Linux and Windows.

Krew also helps kubectl plugin developers: You can package and distribute 
your plugins on multiple platforms easily and makes them discoverable 
through a centralized plugin repository with Krew.

run "kubectl krew --help" after installation

*** This script will install krew via brew, then install kubectl plugins via krew install xyx. 
*** Press ENTER to continue, or CTRL+C to quit"
EndOfKrewIntroMessage

echo "$KREW_INTRO_MSG"
read -s

# print each line to output so can trace this in console
set -x

#
# install "krew" - a package manager for kubectl plugins
#
brew install krew
brew upgrade krew

# list all the krew plugins for fun
kubectl krew search

#
# Note: after "kubectl krew install foobar", you can run "kubectl foobar"
#

#
# INSTALL LOG TAILING PLUGIN ("stern")
#

# stern - my favorite for logs, because the CLI interface for it doesn't suck
kubectl krew install stern

#
# FOR FIGURING OUT WTF IS HAPPENING IN K8S (HIGH LEVEL)
#

# ktop - A top tool to display workload metrics        
kubectl krew install ktop

# viewnode - Displays nodes with their pods and containers  
kubectl krew install viewnode

# get-all - Like `kubectl get all` but _really_ everything
# (MATT) this will show you the CRD's that Cartographer defines, not just pods / etc 
kubectl krew install get-all

# images - Show container images used in the cluster.
kubectl krew install images

# janitor - Lists objects in a problematic state  
kubectl krew janitor

# tree - Show a tree of object hierarchies through owner
kubectl krew install tree

# resource-capacity - Provides an overview of resource requests, limits, ...
kubectl krew install resource-capacity

#
# FOR SLEUTHING SOMETHING SPECIFIC
#

# fields - Grep resources hierarchy by field name
# (MATT) - for when you want to search all k8s "things" for some field/value buried inside
kubectl krew install fields

# grep - Filter Kubernetes resources by matching their 
kubectl krew install grep

# fuzzy - Fuzzy and partial string search for kubectl 
kubectl krew install fuzzy

# pod-dive - Shows a pod's workload tree and info inside a node  yes
kubectl krew install pod-dive

# pod-inspect - Get all of a pod's details at a glance              yes
kubectl krew install pod-inspect

# pod-lens - Show pod-related resources                          yes
kubectl krew install pod-lens

# upgrade all plugins (why not, in case an older version was already installed)
kubectl krew upgrade

#######
#######
#######

set +x
echo "*** KREW PLUGINS INSTALLED:"
set -x

kubectl krew list

# disable tracing
set +x

read -r -d '' HELP_MSG << EndOfHelpMessage

KREW PLUGIN INSTALLTION COMPLETE. 

GET HELP:
kubectl toolName --help
kubectl krew info toolName

EndOfHelpMessage

echo "$HELP_MSG"

#
# to tail logs...
#
read -r -d '' STERN_MSG << EndOfSternMessage
kubectl stern --help      

Tail multiple pods and containers from Kubernetes

Usage:
  stern pod-query [flags]

Flags:
  -A, --all-namespaces             If present, tail across all namespaces. A specific namespace is ignored even if specified with --namespace.
      --color string               Force set color output. 'auto':  colorize if tty attached, 'always': always colorize, 'never': never colorize. (default "auto")
      --completion string          Output stern command-line completion code for the specified shell. Can be 'bash', 'zsh' or 'fish'.
  -c, --container string           Container name when multiple containers in pod. (regular expression) (default ".*")
      --container-state strings    Tail containers with state in running, waiting or terminated. To specify multiple states, repeat this or set comma-separated value. (default [running])
      --context string             Kubernetes context to use. Default to current context configured in kubeconfig.
      --ephemeral-containers       Include or exclude ephemeral containers. (default true)
  -e, --exclude strings            Log lines to exclude. (regular expression)
  -E, --exclude-container string   Container name to exclude when multiple containers in pod. (regular expression)
      --exclude-pod string         Pod name to exclude. (regular expression)
      --field-selector string      Selector (field query) to filter on. If present, default to ".*" for the pod-query.
  -h, --help                       help for stern
  -i, --include strings            Log lines to include. (regular expression)
      --init-containers            Include or exclude init containers. (default true)
      --kubeconfig string          Path to kubeconfig file to use. Default to KUBECONFIG variable then ~/.kube/config path.
  -n, --namespace strings          Kubernetes namespace to use. Default to namespace configured in kubernetes context. To specify multiple namespaces, repeat this or set comma-separated value.
  -o, --output string              Specify predefined template. Currently support: [default, raw, json] (default "default")
  -p, --prompt                     Toggle interactive prompt for selecting 'app.kubernetes.io/instance' label values.
  -l, --selector string            Selector (label query) to filter on. If present, default to ".*" for the pod-query.
  -s, --since duration             Return logs newer than a relative duration like 5s, 2m, or 3h. (default 48h0m0s)
      --tail int                   The number of lines from the end of the logs to show. Defaults to -1, showing all logs. (default -1)
      --template string            Template to use for log lines, leave empty to use --output flag.
  -t, --timestamps                 Print timestamps.
      --timezone string            Set timestamps to specific timezone. (default "Local")
  -v, --version                    Print the version and exit.

Examples:


# tail all logs that match a *label* query (selector)

# tail everything in a namespace (kube-system)
k stern ".*" -n kube-system

# tail everything in a namespace (default)
k stern ".*" -n default

# Suppose we want to tail all pods with the label "tier=control-plane"

 ᐅ k get po -n kube-system           
NAME                                        READY   STATUS    RESTARTS   AGE
coredns-6d4b75cb6d-f5cst                    1/1     Running   0          4m45s
coredns-6d4b75cb6d-nfx7r                    1/1     Running   0          4m45s
etcd-sol-control-plane                      1/1     Running   0          4m59s
kindnet-kwlzm                               1/1     Running   0          4m45s
kube-apiserver-sol-control-plane            1/1     Running   0          4m59s
kube-controller-manager-sol-control-plane   1/1     Running   0          5m1s
kube-proxy-rwp7r                            1/1     Running   0          4m45s
kube-scheduler-sol-control-plane            1/1     Running   0          5m

(⎈ |kind-sol:kube-system)~/gh/halcyondude/devenv (main ✔) ᐅ k describe po kube-apiserver-sol-control-plane
Name:                 kube-apiserver-sol-control-plane
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 sol-control-plane/172.18.0.3
Start Time:           Wed, 13 Jul 2022 14:09:03 -0400
Labels:               component=kube-apiserver
                      tier=control-plane
Annotations:          kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 172.18.0.3:6443
                      kubernetes.io/config.hash: b6b4043001f6e921e931826302d657a1
                      kubernetes.io/config.mirror: b6b4043001f6e921e931826302d657a1
                      kubernetes.io/config.seen: 2022-07-13T18:09:02.903548000Z
                      kubernetes.io/config.source: file
                      seccomp.security.alpha.kubernetes.io/pod: runtime/default
Status:               Running
IP:                   172.18.0.3

<snip>


# tail all logs that have the label: tier=control-plane
k stern -n kube-system --selector "tier=control-plane"
k stern -A -l "tier=control-plane"

# tail all logs that match a *field* query (selector). Note: no shorthand for --field-selector
Above pod has annotation "kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 172.18.0.3:6443"

# all logs matching that exact annotation (field)
k stern -A --field-selector "kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint=172.18.0.3:6443"

# same query, but this time allow for any value (.*) instead of "172.18.0.3:6443
k stern -A --field-selector "kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint=.*"

EndOfSternMessage

echo ""
echo "*** HOW TO TAIL LOGS WITH stern:"
echo ""

echo "$STERN_MSG" 

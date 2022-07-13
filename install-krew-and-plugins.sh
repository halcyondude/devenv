#!/usr/bin/env bash

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
# INSTALL LOG TAILING PLUGINS
#

# stern - my favorite for logs, because the CLI interface for it doesn't suck
kubectl krew install stern

# tail - Stream logs from multiple pods and containers
kubectl krew install tail

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

# tail all logs in a namespace
k stern --namespace default
k stern -n default

# tail all logs that match a *label* query (selector)
k stern --all-namespaces --selector YOUR_SELECTOR_QUERY
k stern -A -l YOUR_SELECTOR_QUERY

# tail all logs that match a *field* query (selector). Note: no shorthand for --field-selector
k stern --all-namespaces --field-selector YOUR_FIELD_QUERY
k stern -A --field-selector YOUR_FIELD_QUERY 

# tail all logs (cluster wide) generated in the past 7 minutes w/ timestamps
k stern --all-namespaces --timestamps --since 7m
k stern -A -t -s 7m
EndOfSternMessage

echo ""
echo "*** HOW TO TAIL LOGS WITH stern:"
echo ""

echo "$STERN_MSG" 

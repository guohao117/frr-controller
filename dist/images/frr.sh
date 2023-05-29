#!/bin/bash
#set -euo pipefail

# The argument to the command is the operation to be performed
# ovn-master ovn-controller ovn-node display display_env ovn_debug
# a cmd must be provided, there is no default
cmd=${1:-""}

kubeconfig=$HOME/.kube/config

ovn_pod_host=${K8S_NODE:-$(hostname)}
ovn_daemonset_version=${OVN_DAEMONSET_VERSION:-"3"}
ovnkube_version="3"
ovnkubelogdir=/var/log/ovn-kubernetes

if [[ -f /var/run/secrets/kubernetes.io/serviceaccount/token ]]; then
  k8s_token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
else
  k8s_token=${K8S_TOKEN}
fi

# certs and private keys for k8s
K8S_CACERT=${K8S_CACERT:-/var/run/secrets/kubernetes.io/serviceaccount/ca.crt}

# =========================================

display_version() {
  echo " =================== hostname: ${ovn_pod_host}"
  echo " =================== daemonset version ${ovn_daemonset_version}"
  if [[ -f /root/git_info ]]; then
    disp_ver=$(cat /root/git_info)
    echo " =================== Image built from ovn-kubernetes ${disp_ver}"
    return
  fi
}

check_ovn_daemonset_version() {
  ok=$1
  for v in ${ok}; do
    if [[ $v == ${ovn_daemonset_version} ]]; then
      return 0
    fi
  done
  echo "VERSION MISMATCH expect ${ok}, daemonset is version ${ovn_daemonset_version}"
  exit 1
}

# v3 - run frr controller
frr-controller() {
  check_ovn_daemonset_version "3"

  echo "=============== frr-controller ========== MASTER ONLY"
  /usr/bin/frr-controller \
    -log_dir=${ovnkubelogdir} \
    -log_file=frr-controller.log \
    -kubeconfig=${kubeconfig}

  echo "=============== frr-controller ========== running"
}


echo "================== frr.sh --- version: ${ovnkube_version} ================"

echo " ==================== command: ${cmd}"
display_version

case ${cmd} in
"frr-controller") # pod frr-controller container frr-controllers
  frr-controller
  ;;
*)
  echo "invalid command ${cmd}"
  echo "valid v3 commands: frr-controller"
  exit 0
  ;;
esac

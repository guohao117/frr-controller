FROM localhost/ovn-daemonset-f:dev

USER root

COPY frr-controller /usr/bin
COPY frr.sh /root/
COPY config /root/.kube/config

WORKDIR /root
ENTRYPOINT /root/frr.sh

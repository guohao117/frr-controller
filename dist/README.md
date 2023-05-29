# frr-controller

## build frr controller
```sh
cd frr-controller
go mod vendor
go build -o frr-controller .
```

## copy
```sh
cd frr-controller
cp ./frr-controller ./dist/images/frr-controller
cp /root/.kube/config ./dist/images/config
```

## build image
```sh
cd frr-controller/dist/images
docker build -t nocsys/frr:0.1-saic -f Dockerfile .
```

## run frr controller
```sh
cd frr-controller/dist/yaml
kubectl apply -f frr-setup.yaml
kubectl apply -f frr.yaml
```
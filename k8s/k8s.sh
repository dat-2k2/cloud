kubectl create -f namespace.yaml 

kubectl apply -f db.yaml 
kubectl apply -f app.yaml

kubectl get pods -n nguen-ns

kubectl logs -l app=nguen-iam-deploy -n nguen-ns
kubectl delete -f db.yaml -f app.yaml
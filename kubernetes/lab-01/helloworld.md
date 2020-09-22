# Running your first helloworld


1. Set up your first Kubernetes helloworld application
2. Run your application in a minikube environment
3. Expose application via a nodeport and see it running

4. Understand the basics of the deployment and service
5. Understand what we created
6. Create a simple single yaml file for deployment and service
7. Verify that the application is working as expected


#### Commands to run

pwd
ls -al

kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.4
kubectl expose deployment hello-minikube --type=NodePort --port=8080
kubectl get services hello-minikube
minikube service hello-minikube
kubectl port-forward service/hello-minikube 7080:8080

#### Using YML file to create application

kubectl create -f helloworld.yaml
kubectl expose deployment helloworld --type=NodePort
minikube service helloworld


kubectl create -f helloworld-deployment.yml
kubectl create -f helloworld-service.yml
minikube service helloworld-service

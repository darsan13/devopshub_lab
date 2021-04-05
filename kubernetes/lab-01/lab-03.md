# Adding labels to the application


1. Adding labels during build time
2. Viewing labels
2. Adding labels to running pods
3. Deleting a label
4. Searching by labels
5. Extending the label concept to deployments/services

### Adding labels during build time

kubectl create -f helloworld-pod-with-labels.yml


### Viewing labels

kubectl get pods --show-labels

### Adding labels to running pods
To add labels to a running pod, you can use the `kubectl label` command as follows: `kubectl label po/helloworld app=helloworld`. This adds the label `app` with the value `helloworld` to the pod.

To update the value of a label, use the `--overwrite` flag in the command as follows: `kubectl label po/helloworld app=helloworldapp --overwrite` 

### Deleting a label
kubectl label po/helloworld app-



### Searching by labels

kubectl create -f kubectl create -f sample-infrastructure-with-labels.yml


Looking at these applications running from a high level makes it hard to see what's going on with the infrastructure.

kubectl get pods

kubectl get pods --show-labels

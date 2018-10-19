# Python kubernetes api client container

Container with installed python and kubernetes plugins.

## How to use

### Example to call api from inside a pod
```python
from __future__ import print_function

from pprint import pprint

import kubernetes
import os
from kubernetes import config
from kubernetes.client.rest import ApiException

# Configure API key authorization: BearerToken
configuration = config.load_incluster_config()

# create an instance of the API class
api_instance = kubernetes.client.AppsV1Api(kubernetes.client.ApiClient(configuration))
name = os.environ['STATEFULSET']  # str | name of the StatefulSet
namespace = os.environ['TARGET_NAMESPACE']  # str | object name and auth scope, such as for teams and projects
pretty = 'false'  # str | If 'true', then the output is pretty printed. (optional)

try:
    api_response = api_instance.read_namespaced_stateful_set_status(name, namespace, pretty=pretty)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling AppsV1Api->read_namespaced_stateful_set_status: %s\n" % e)
```

### Example pod calling
Example mounts a python script to container and executes it when starting.
```yaml
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: mydeployment
  namespace: mynamespace
spec:
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      namespace: mynamespace
    spec:
      containers:
        - name: python-kube-client
          image: chris060986/python-kube-client:latest
          imagePullPolicy: Always   
          command: [ "python"]
          args: [ "/app/python/myScript.py" ]
          env:
          - name: STATEFULSET
            value: stateful-set-name    
          - name: TARGET_NAMESPACE
            value: namespace-of-stateful-set
          volumeMounts:
          - name: actacor-py-scripts
            mountPath: /app/python 
      volumes:
      - name: actacor-py-scripts
        configMap:
          name: kube-api-configmap 
```
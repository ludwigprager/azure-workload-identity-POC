
# TL;DR
```
git clone http://lyra.g1:3000/lprager/azure-workload-identity-POC.git
./azure-workload-identity-POC/10-create.sh bla
```

# Preconditions
- install podman (or docker)
- assign yourself the RBAC role 'Key Vault Administrator' for the subscription you want to run this POC in.
- select a unique name for the [`key vault`](./set-env.sh#L7)

# References

https://github.com/Azure/azure-workload-identity/blob/main/docs/book/src/introduction.md  
https://azure.github.io/azure-workload-identity/docs/quick-start.html  
https://github.com/Azure/azure-workload-identity/pkgs/container/azure-workload-identity%2Fmsal-go  

https://github.com/HoussemDellai/docker-kubernetes-course/tree/main/23_workload_identity  

https://www.youtube.com/watch?v=paaFMgWpCjQ  
https://www.youtube.com/watch?v=i2GobU0Wg48  

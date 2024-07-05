# Instructions
## Overview

This infra-module serves as an example implementation of Azure's 'workload identity.' There is already a POC from Microsoft on this topic, along with some excellent presentations. However, the code is not immediately functional. Therefore, this module:

- Uses specific versions and tags
- Ensures the code is largely self-contained, with only Podman as a prerequisite
- Scripts are idempotent and will 'exit on first error'

## Prerequisites

- Podman: Ensure Podman is installed and properly configured on your system.

## Step-by-Step Guide

1. Clone the Repository

```
git clone https://github.com/ludwigprager/azure-workload-identity-POC.git
```

2. Configuration
- select a unique name for the [`key vault`](./set-env.sh#L7)
- select or create a subscription for this POC to run.

3. Run Idempotent Scripts
Execute the provided scripts. These scripts are designed to be idempotent, meaning they can be run multiple times without causing issues. They will also exit on the first error encountered to prevent further issues.

```
./azure-workload-identity-POC/10-create.sh <your subscription name>
```



# References

https://github.com/Azure/azure-workload-identity/blob/main/docs/book/src/introduction.md  
https://azure.github.io/azure-workload-identity/docs/quick-start.html  
https://github.com/Azure/azure-workload-identity/pkgs/container/azure-workload-identity%2Fmsal-go  

https://www.youtube.com/watch?v=paaFMgWpCjQ  
https://www.youtube.com/watch?v=i2GobU0Wg48  

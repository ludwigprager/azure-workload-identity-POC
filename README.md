# Instructions
## Overview

This infra-module serves as an example implementation of Azure's 'workload identity.' There is already a POC from Microsoft on this topic, along with some excellent presentations. However, the code is not immediately functional. Therefore, this module:

- Uses specific versions and tags
- Ensures the code is largely self-contained, with only Podman as a prerequisite
- Scripts are idempotent and will 'exit on first error'

## More Info

Please visit https://www.celp.de/azure-wi for more info about this POC.


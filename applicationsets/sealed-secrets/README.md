# Sealed-Secrets ApplicationSet

This directory contains the ArgoCD ApplicationSet implementation for the sealed-secrets namespace, migrated from the original helmfile-based approach.

## Migration Approach

The sealed-secrets namespace was chosen as the first migration target due to its simplicity:
- Single component deployment (sealed-secrets controller)
- Simple configuration with minimal templating
- No complex feature flags or scaling parameters

## Implementation Details

The ApplicationSet uses a List generator with a single element to deploy the sealed-secrets controller. This maintains the same functionality as the original helmfile implementation:

- Uses the same Bitnami chart source
- Maintains the same version (2.17.2)
- Preserves the same namespace and labels
- Adds ArgoCD-specific sync policies for automated management

## Usage

This ApplicationSet can be applied directly to an ArgoCD instance:

```bash
kubectl apply -f applicationset.yaml -n argocd
```

## Comparison with Helmfile Approach

| Feature | Helmfile Implementation | ApplicationSet Implementation |
|---------|------------------------|------------------------------|
| Chart Source | Bitnami repository | Bitnami repository |
| Chart Version | 2.17.2 | 2.17.2 |
| Namespace | sealed-secrets | sealed-secrets |
| Labels | launchpad.graphops.xyz/namespace, launchpad.graphops.xyz/layer | Same labels preserved |
| Configuration | Values through helmfile | Values through ApplicationSet |
| Deployment | Manual helmfile apply | Automated through ArgoCD |

## Future Enhancements

For more complex namespaces, additional features would be needed:
- Matrix generators for feature flags
- Value overrides for different environments
- Template patches for complex configurations

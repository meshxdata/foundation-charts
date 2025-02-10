# backend

![Version: 0.1.9](https://img.shields.io/badge/Version-0.1.9-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Helm chart for the Foundation API

## Values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| **affinity** | object | `{}` | Node affinity rules to schedule pods on specific nodes. |
| **autoscaling.enabled** | bool | `true` | Enable or disable horizontal pod autoscaling. |
| **autoscaling.maxReplicas** | int | `5` | The maximum number of pod replicas when autoscaling. |
| **autoscaling.minReplicas** | int | `1` | The minimum number of pod replicas when autoscaling. |
| **autoscaling.targetCPUUtilizationPercentage** | int | `80` | Target average CPU utilization percentage for autoscaling. |
| **autoscaling.targetMemoryUtilizationPercentage** | int | `80` | Target average memory utilization percentage for autoscaling. |
| **config.host** | string | `"0.0.0.0"` | The host address on which the application listens. |
| **config.port** | int | `9000` | The port number on which the application listens. |
| **config.postgres.database** | string | `"foundation"` | The name of the PostgreSQL database to connect to. |
| **config.postgres.host** | string | `"foundation-postgres"` | The hostname or service name for PostgreSQL. |
| **config.postgres.pool_max_size** | int | `5` | The maximum number of connections in the PostgreSQL connection pool. |
| **config.postgres.pool_min_size** | int | `1` | The minimum number of connections in the PostgreSQL connection pool. |
| **config.postgres.port** | int | `5432` | The port on which PostgreSQL is running. |
| **config.postgres.user** | string | `"foundation"` | The username for connecting to PostgreSQL. |
| **development.enabled** | bool | `false` | Enables development-specific features or configurations. |
| **image.pullPolicy** | string | `"Always"` | The Kubernetes image pull policy. |
| **image.repository** | string | `"676206939231.dkr.ecr.eu-north-1.amazonaws.com/foundation/backend"` | The container image repository for the backend. |
| **image.tag** | string | `"latest"` | The tag for the container image. |
| **imagePullSecrets** | list | `[]` | Secrets to use for pulling private images. |
| **ingress.annotations."kubernetes.io/ingress.class"** | string | `"tailscale"` | Specifies the ingress class to use. |
| **ingress.annotations."kubernetes.io/tls-acme"** | string | `"true"` | Enables automatic TLS certificate generation with ACME. |
| **ingress.className** | string | `"tailscale"` | The ingress class name. |
| **ingress.enabled** | bool | `true` | Enable or disable ingress for the application. |
| **ingress.hosts[0].host** | string | `"api"` | The hostname for the ingress resource. |
| **ingress.hosts[0].paths[0].path** | string | `"/"` | The path to route traffic to. |
| **ingress.hosts[0].paths[0].pathType** | string | `"ImplementationSpecific"` | The type of path matching to use (e.g., `Prefix`, `Exact`, or `ImplementationSpecific`). |
| **labels.app** | string | `"foundation-api"` | The application label used for the pods and services. |
| **livenessProbe.httpGet.path** | string | `"/api/.well-known/status"` | The HTTP path for the liveness probe. |
| **livenessProbe.httpGet.periodSeconds** | int | `10` | How often (in seconds) to perform the liveness probe. |
| **livenessProbe.httpGet.port** | int | `9000` | The port to use for the liveness probe. |
| **livenessProbe.initialDelaySeconds** | int | `10` | The initial delay before performing the first liveness probe. |
| **nodeSelector** | object | `{}` | Node selector rules for scheduling pods. |
| **pdb.enabled** | bool | `true` | Enable or disable the PodDisruptionBudget. |
| **pdb.maxUnavailable** | string | `"50%"` | The maximum number or percentage of unavailable pods during a disruption. |
| **pdb.selector.app** | string | `"backend"` | The app label used to match pods for the PodDisruptionBudget. |
| **podAnnotations** | object | `{}` | Annotations to add to the pod template. |
| **podSecurityContext.fsGroup** | int | `2000` | The file system group ID for the pods. |
| **readinessProbe.initialDelaySeconds** | int | `60` | The initial delay before performing the first readiness probe. |
| **readinessProbe.tcpSocket.periodSeconds** | int | `10` | How often (in seconds) to perform the readiness probe. |
| **readinessProbe.tcpSocket.port** | int | `9000` | The port to use for the readiness probe. |
| **replicaCount** | int | `1` | The initial number of pod replicas. |
| **resources** | object | `{}` | Resource requests and limits for the containers. |
| **securityContext.capabilities.drop[0]** | string | `"ALL"` | The capabilities to drop for the container. |
| **securityContext.readOnlyRootFilesystem** | bool | `true` | Specifies if the container’s root filesystem is read-only. |
| **securityContext.runAsNonRoot** | bool | `true` | Ensures the container runs as a non-root user. |
| **securityContext.runAsUser** | int | `1000` | The user ID for running the container. |
| **service.port** | int | `80` | The port exposed by the Kubernetes service. |
| **service.type** | string | `"ClusterIP"` | The type of Kubernetes service (e.g., `ClusterIP`, `NodePort`, `LoadBalancer`). |
| **serviceAccount.annotations** | object | `{}` | Annotations to add to the service account. |
| **serviceAccount.create** | bool | `false` | Enable or disable the creation of a service account. |
| **serviceAccount.name** | string | `"default"` | The name of the service account to use. |
| **tolerations** | list | `[]` | Tolerations for scheduling pods on tainted nodes. |
| **vpa.enabled** | bool | `false` | Enable or disable the Vertical Pod Autoscaler. |
| **vpa.maxAllowed.cpu** | string | `"800m"` | The maximum CPU resources allowed by the Vertical Pod Autoscaler. |
| **vpa.maxAllowed.memory** | string | `"512Mi"` | The maximum memory resources allowed by the Vertical Pod Autoscaler. |
| **vpa.minAllowed.cpu** | string | `"100m"` | The minimum CPU resources allowed by the Vertical Pod Autoscaler. |
| **vpa.minAllowed.memory** | string | `"128Mi"` | The minimum memory resources allowed by the Vertical Pod Autoscaler. |
| **vpa.updateMode** | string | `"Auto"` | The update mode for the Vertical Pod Autoscaler (e.g., `Auto`, `Off`, `Initial`). |
# hive-metastore helm chart

## Configuration

The following tables lists the configurable parameters of the hive-metastore chart and their default values.

| Parameter                  | Description                                             | Default                                                                     |
|----------------------------|---------------------------------------------------------|-----------------------------------------------------------------------------|
| `nameOverride`             | String to partially override hive-metastore.fullname    | `""`                                                                        |
| `fullnameOverride`         | String to fully override hive-metastore.fullname        | `""`                                                                        |
| `image.repository`         | The repository to use for the hive-metastore image      | `swr.ap-southeast-1.myhuaweicloud.com/nexus-core/nexus-core-hive-metastore` |
| `image.pullPolicy`         | The pull policy to use for the hive-metastore image     | `IfNotPresent`                                                              |
| `image.tag`                | Image tag. Defaults to the chart's AppVersion           | `""`                                                                        |


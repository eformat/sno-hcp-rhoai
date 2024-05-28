# sno-hcp-rhoai

Single Node OpenShift / Hosted Control Planes / RHOAI on AWS.

- sno hub (m6i.8xlarge)
- sno gpu workload hcp cluster (g6.4xlarge)

The model is scalable to full size clusters of course. This is proving out the configuration for self-hosting workload RHOAI clusters using HCP in AWS.

Hub cluster is deployed using [sno on spot](https://github.com/eformat/sno-for-100).

Currently [HCP on AWS is tech.preview](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.10/html-single/clusters/index#hosting-service-cluster-configure-aws) - so the creation of HCP AWS  pieces must be done as two step process.

Export the environment:

```bash
export AWS_CREDS=~/tmp/hcp/credentials
export AWS_DEFAULT_REGION=us-east-2
export AWS_DEFAULT_ZONES="us-east-2b"
export INSTANCE_TYPE=g6.4xlarge
export PULL_SECRET=~/tmp/pull-secret
export SSH_KEY=~/.ssh/id_rsa.pub
export CLUSTER_NAME=sno-dsc-all
export BASE_DOMAIN=sandbox.opentlc.com
export NODE_POOL_REPLICAS=1
export RELEASE_IMAGE=quay.io/openshift-release-dev/ocp-release:4.15.13-multi
export ROOT_VOLUME_SIZE=200
export INFRA_AVAILABILITY=SingleReplica
export CONTROL_AVAILABILITY=SingleReplica
export BUCKET_NAME=hcp-clusters
export BUCKET_REGION=${AWS_DEFAULT_REGION}
```

Render the YAML for HCP spoke cluster `sno-dsc-all`

```bash
hcp create cluster aws \
    --name ${CLUSTER_NAME} \
    --infra-id ${CLUSTER_NAME} \
    --infra-availability-policy ${INFRA_AVAILABILITY} \
    --control-plane-availability-policy ${CONTROL_AVAILABILITY} \
    --instance-type ${INSTANCE_TYPE} \
    --base-domain ${BASE_DOMAIN} \
    --aws-creds ${AWS_CREDS} \
    --pull-secret ${PULL_SECRET} \
    --region ${AWS_DEFAULT_REGION} \
    --zones ${AWS_DEFAULT_ZONES} \
    --ssh-key ${SSH_KEY} \
    --node-pool-replicas ${NODE_POOL_REPLICAS} \
    --release-image ${RELEASE_IMAGE} \
    --root-volume-size ${ROOT_VOLUME_SIZE} \
    --render
```

This will create the AWS resources and output the YAML we use in GitOps within this repo.

We use Hashi Vault and AVP as the secrets provider in the HUB ACM cluster. Currently kv2 looks like this:

```bash
vault kv put kv/$PROJECT_NAME/$APP_NAME \
  PULL_SECRET="${PULL_SECRET}" \
  ETCD_DECRYPTION_KEY="${ETCD_DECRYPTION_KEY}" \
  HTPASSWORD="${HTPASSWORD}"
```

# Using Google Cloud Workstations for SciML

## Rough notes on usage for now

Clone this repo into somewhere like Cloudshell.  Need:
- `gcloud` to be already authenticated
- `GOOGLE_CLOUD_PROJECT` to be set to the (preferably new) project you wanna
  use for this
- a bucket to keep terraform state

Then
```
cp envrc.example .envrc
```
edit to taste... then
```
source .envrc
cd terraform
cp backend.conf.example backend.conf
```
edit to taste.


### Create network stuff

Change to `terraform/network` and
```
terraform init -backend-config ../backend.conf
terraform plan
terraform apply
```

### Create a workstations cluster and some example workstations

Change to `terraform/workstations` and
```
terraform init -backend-config ../backend.conf
terraform plan
terraform apply
```

This takes forever... creating a Cloud Workstations Cluster takes
just at 20 minutes.  This makes it not really useful for tutorials.

We'll have to find some workarounds.  Having the managed control plane
(cluster) helps enterprise customers, but gets in the way of a one-off
tutorial.  For now, this is what we're doing.

### Launch and use workstations

TODO


### Clean up after yourself

This stuff costs money.

TODO


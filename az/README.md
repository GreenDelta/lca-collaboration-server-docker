# Setup the LCA Collaboration Server on Azure from scratch

## Requirements

The following tools are necessary to run these commands:

- [Azure >=2.66](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform >=1.9.8](https://www.terraform.io/)
- [Ansible >=2.17.6](https://www.ansible.com/)

## Login to Azure

```bash
az login
```

It will fail because it needs to do multi-factor authentication, but it should output your tenant ID.

```bash
az login --tenant TENANT_ID
```

## Export the environment variables

Create the following environment variables:

```bash
TF_VAR_AZURE_SUBSCRIPTION_ID=<please_fill_in>
TF_VAR_MYSQL_ROOT_USER=<please_fill_in>
TF_VAR_MYSQL_ROOT_PASSWORD=<please_fill_in>
TF_VAR_ELASTICSEARCH_ADMIN_USER=<please_fill_in>
```

These can be store in an `az/.env` file and loaded with:

```bash
cd az
export $(grep -v '^#' .env | xargs)
```

## Create the Azure infrastructure

This will create all the resources on Azure and provision the ElasticSearch VM with an Ansible playbook.

It can take up to 15 minutes.

```bash
cd az
terraform init
terraform apply
```

## Configure the collaboration server

`terraform apply` will output the public IP address of the Application Gateway (`app_gateway_public_ip`) and the private IP of the ElasticSearch VM (`elasticsearch_vm_private_ip`) as well as the public one (`elasticsearch_vm_public_ip`).
You can use those values to configure your LCA Collaboration Server.

The collaboration server will run on port `8080`, thus http://<app_gateway_public_ip>:8080 will bring you to the login page of the collaboration server. The initial admin crendentials should be changed, see also the [configuration guide](https://www.openlca.org/lca-collaboration-server-2-configuration-guide/).


| Username        | Password            |
| --------------- | ------------------- |
| `administrator` | `Plea5eCh@ngeMe`    |

The *repositories root directory* is `/opt/collab/git` and the *libraries directory* is `/opt/collab/lib`.

For using the *Search* feature, you first need to enable it in the administration settings under `Enabled features: Search`. For the URL of the OpenSearch service, you need to set it to `http://<elasticsearch_vm_private_ip>:9200`:


| Schema | Url                       | Port  |
| ------ | ------------------------- | ----- |
| `http` | `elasticsearch_vm_private_ip` # not localhost! | `9200`|

## Debugging

### Check if the app is running

```bash
curl -I $(terraform output -raw app_gateway_public_ip):8080
```

### Connect to the ElasticSearch VM

```bash
ssh $TF_VAR_ELASTICSEARCH_ADMIN_USER@$(terraform output -raw elasticsearch_vm_public_ip)
```

### Show more verbose when running Terraform

```bash
export TF_LOG=DEBUG
terraform apply
```

## Destroy the Azure infrastructure (/!\ this will delete all the data)

To destroy all the resources on Azure (thus deleting all the data), run:

```bash
cd az
terraform destroy
```

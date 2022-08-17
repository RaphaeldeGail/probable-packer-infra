<!-- BEGIN_TF_DOCS -->
# Probable Packer Infra

This code sets up a simple infrastructure on GCP for creating packer instances on it.

## Infrastructure description

The code creates a private Google network, hosting the packer instance.

The network has a default route to the internet only availables for instances with a the name of the build as a tag (the **name** variable).

The network also allows inbound SSH connections to any instance with the same tag as for the route.

This simple setup allows for a creation of a google instance, with access to the internet, and reachable by a packer client for provisioning.

## Usage

Set the values of the required variables, either in a file or with environment variables.

Authenticate to Google Cloud Platform with a relevant account or set the environment variable **GOOGLE\_APPLICATION\_CREDENTIALS** to the path of a JSON service account key.

Simply run:

```bash
terraform init
terraform apply
```

with appropriate options.

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.1.2 |
| google | >= 4.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.to_front](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_network.network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_route.default_route](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |
| [google_compute_subnetwork.subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| workspace | The workspace that will be created on GCP. Requires the **name** of the build (e.g "bounce"), the ID of a GCP **project** and the **region** of deployment on GCP. The **name** attributes must contain only lowercase letters. | ```object({ name = string project = string region = string })``` | n/a |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
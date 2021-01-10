## archiveteam-infra

Archive Team infra but focused on individual projects

forked from https://gitlab.com/diggan/archiveteam-infra

## Installation

Get a DigitalOcean API Token. https://cloud.digitalocean.com/account/api/tokens/new

Upload your ssh key to DigitalOcean. You can do that here https://cloud.digitalocean.com/account/security?i=c84be4 Make a copy of the ssh fingerprint as you need it later.

Copy `terraform.tfvars.dist` to `terraform.tfvars`, filling out the wanted values.

The `warrior_project` var needs to be the name of a docker container on `atdr.meo.ws/archiveteam/$warrior_project`

Run `terraform init`
Now run `terraform apply`.

### LICENSE: MIT (2018) DIGGAN

wget https://hashicorp-releases.yandexcloud.net/terraform/1.11.4/terraform_1.11.4_linux_amd64.zip 
unzip terraform_1.11.4_linux_amd64.zip -d terraform-temp
cp terraform-temp/terraform ~/.local/bin/
wget https://hashicorp-releases.yandexcloud.net/terraform-provider-openstack/1.54.1/terraform-provider-openstack_1.54.1_linux_amd64.zip
unzip terraform-provider-openstack_1.54.1_linux_amd64.zip -d terraform-temp
cp terraform-temp/terraform-provider-openstack_v1.54.1 ~/.local/bin/
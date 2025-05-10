rm -rf /tmp/terraform-install
mkdir -p /tmp/terraform-install
cd /tmp/terraform-install
wget https://hashicorp-releases.yandexcloud.net/terraform/1.11.4/terraform_1.11.4_linux_amd64.zip 
unzip terraform_1.11.4_linux_amd64.zip -d terraform-tmp
sudo cp terraform-tmp/terraform /usr/bin/
wget https://hashicorp-releases.yandexcloud.net/terraform-provider-openstack/1.54.1/terraform-provider-openstack_1.54.1_linux_amd64.zip
unzip terraform-provider-openstack_1.54.1_linux_amd64.zip -d terraform-provider-openstack-tmp
sudo cp terraform-provider-openstack-tmp/terraform-provider-openstack_v1.54.1 /usr/bin/
ansible-playbook -e ssh_private_key=./secret/nguen-tf-yandex -e tf_dir=./yandex -e tf_rc=./.terraformrc -i .ini infra.yaml
#!/bin/bash

echo "Ender your DNS-name"
read DNSNAME
URL=`cat url`
PASS=`cat pass`
TENANT=`cat tenant`

RGNAME="RG_Laba2"
VMNAME="VM-laba2"
PUBLICIPADDRESS="PublicIPAddress_Laba2"
#DNSNAME="vm-laba2"
LOCATIOM="westeurope"
#AZUREDNS=".cloudapp.azure.com"
#FULLNDSNAME=$DNSNAME$LOCATIOM$AZUREDNS

echo "-------------START-------------"
echo "###########################################################"
echo ""
echo "Install Azure CLI"
echo ""
echo "###########################################################"
sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
echo "###########################################################"
echo ""
echo "Authorization to Azure"
echo ""
echo "###########################################################"
az login --service-principal -u $URL -p $PASS --tenant $TENANT
echo "###########################################################"
echo ""
echo "Create a new virtual machine"
echo ""
echo "###########################################################"
# Create a resource group.
az group create --name $RGNAME --location $LOCATIOM
az network public-ip create --resource-group $RGNAME --name $PUBLICIPADDRESS
az network public-ip create --resource-group $RGNAME --name $PUBLICIPADDRESS --dns-name $DNSNAME
az network public-ip update --resource-group $RGNAME --name $PUBLICIPADDRESS --allocation-method static
# Create a new virtual machine, this creates SSH keys if not present.
az vm create --resource-group $RGNAME --name $VMNAME --image UbuntuLTS --admin-username alex --size Standard_B1s --public-ip-address $PUBLICIPADDRESS --generate-ssh
# Open port 80 to allow web traffic to host.
az vm open-port --port 80 --resource-group $RGNAME --name $VMNAME --priority 1001
#az vm open-port --port 8080 --resource-group $RGNAME --name $VMNAME --priority 1002
az vm run-command invoke -g $RGNAME -n $VMNAME --command-id RunShellScript --scripts @install.sh

#!/bin/bash

readonly LOCATION="westus2"
readonly PREFIX="rio"
# ACR name must be lower case
readonly AZURE_CONTAINER_REGISTRY_NAME="${PREFIX}acr"
readonly MY_RESOURCE_GROUP="${PREFIX}ResourceGroup"
readonly SERVICE_PLAN="${PREFIX}ServicePlan"
readonly AKS_NAME="${PREFIX}cluster"

readonly GITHUB_URL="https://github.com"
readonly GITHUB_ID="rioriost"
readonly GITHUB_DIR="kd_gallery3"

readonly DOCKER_IMAGE="gallerydocker"
#readonly IMAGE_VERSION="v1.0.0"
readonly WEB_APP_NAME=$PREFIX$DOCKER_IMAGE

readonly MYSQL_NAME="${PREFIX}mysql"
readonly MYSQL_USER=${PREFIX}
readonly MYSQL_PASSWORD="cn7a#a-1"

create_Group () {
	echo "Creating Resource Group..."
	az group create --location $LOCATION --name $MY_RESOURCE_GROUP
}

create_ACR () {
	echo  "Creating Azure Container Registry..."
	az acr create --name $AZURE_CONTAINER_REGISTRY_NAME --resource-group $MY_RESOURCE_GROUP --sku Basic --admin-enabled true
	readonly AZURE_CONTAINER_REGISTRY_PASSWORD=`az acr credential show --output json --name $AZURE_CONTAINER_REGISTRY_NAME | grep "value" | head -1 | cut -d '"' -f 4`
}

build_docker_image () {
	echo "Cloning Dockerfile..."
	git clone "${GITHUB_URL}/${GITHUB_ID}/${GITHUB_DIR}"

	cd $GITHUB_DIR
	echo "Building Docker Image..."
	#FIXME: tag should be automatically incremented
	docker build --tag $DOCKER_IMAGE .
	docker tag $DOCKER_IMAGE $AZURE_CONTAINER_REGISTRY_NAME.azurecr.io/$DOCKER_IMAGE
	docker login $AZURE_CONTAINER_REGISTRY_NAME.azurecr.io --username $AZURE_CONTAINER_REGISTRY_NAME --password $AZURE_CONTAINER_REGISTRY_PASSWORD
	docker push $AZURE_CONTAINER_REGISTRY_NAME.azurecr.io/$DOCKER_IMAGE
	cd -
}

create_WebApp () {
	echo  "Creating Azure Web App..."
	az appservice plan create --name $SERVICE_PLAN --resource-group $MY_RESOURCE_GROUP --is-linux
	az webapp create -g $MY_RESOURCE_GROUP -p $SERVICE_PLAN -n $WEB_APP_NAME --runtime "php|5.6"
	#FIXME: These parameters can't be set correctly. Needed to investigate more.
	az webapp config container set -n $WEB_APP_NAME -g $MY_RESOURCE_GROUP --docker-custom-image-name $DOCKER_IMAGE\
		 -r https://$AZURE_CONTAINER_REGISTRY_NAME.azurecr.io -u $AZURE_CONTAINER_REGISTRY_NAME\
		 -p $AZURE_CONTAINER_REGISTRY_PASSWORD
}

create_AKS (){
	echo  "Creating Azure Container Service..."
	az provider register -n Microsoft.ContainerService
	az aks create --name $AKS_NAME --resource-group $MY_RESOURCE_GROUP
	az aks install-cli
	cat << EOS > $DOCKER_IMAGE.yml
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: my-gallery
spec:
  replicas: 2
  template:
    metadata:
      labels:
        run: my-gallery
    spec:
      containers:
      - name: my-gallery
        image: $AZURE_CONTAINER_REGISTRY_NAME.azurecr.io/$DOCKER_IMAGE
        ports:
        - containerPort: 80
EOS
	kubectl create -f $DOCKER_IMAGE.yml
	az aks get-credentials -n $AKS_NAME -g $MY_RESOURCE_GROUP
}

create_MySQL () {
	echo "Creating Azure DB for MySQL..."
	az mysql server create -g $MY_RESOURCE_GROUP --name $MYSQL_NAME --location $LOCATION -u $MYSQL_USER -p $MYSQL_PASSWORD --performance-tier Basic --compute-units 50
	az mysql server firewall-rule create -g $MY_RESOURCE_GROUP --server $MYSQL_NAME --name AllowAll --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255
	az mysql server update -g $MY_RESOURCE_GROUP -n $MYSQL_NAME --ssl-enforcement Disabled
}

create_Group

create_ACR

build_docker_image

create_WebApp
#create_AKS

create_MySQL
echo "Connection String is ${PREFIX}@${MYSQL_NAME}@${MYSQL_NAME}.mysql.database.azure.com with Password '${MYSQL_PASSWORD}'"

#!/bin/bash

# See https://github.com/yokawasa/OSS-CAD-Handson-TeamA

# Select a region supporting "Azure DB for MySQL"
# See https://azure.microsoft.com/en-us/regions/services/
readonly LOCATION="japaneast"
#readonly LOCATION="westus2"

# If you don't mind the name of each components, change this prefix only
# PREFIX must be lowercase due to ACR name
readonly PREFIX="rio"

readonly AZURE_CONTAINER_REGISTRY_NAME="${PREFIX}acr"
readonly MY_RESOURCE_GROUP="${PREFIX}ResourceGroup"
readonly SERVICE_PLAN="${PREFIX}ServicePlan"
readonly AKS_NAME="${PREFIX}cluster"

# Don't change unless you create a branch
readonly GITHUB_URL="https://github.com"
readonly GITHUB_ID="rioriost"
readonly GITHUB_DIR="kd_gallery3"

readonly DOCKER_IMAGE=$GITHUB_DIR
readonly WEB_APP_NAME=$PREFIX$DOCKER_IMAGE

readonly MYSQL_NAME="${PREFIX}mysql"
readonly MYSQL_PORT="3306"
readonly MYSQL_USER=${PREFIX}
readonly MYSQL_PASSWORD="cn7a#a-1"

create_Group () {
	echo "Creating Resource Group..."
	result=`az group create \
		--output json \
		--location $LOCATION \
		--name $MY_RESOURCE_GROUP \
		| grep provisioningState | cut -d '"' -f 4`
	if [ "${result}" != "Succeeded" ]; then
		echo "Failed to create a resource group."
		exit 1
	fi
}

create_ACR () {
	echo  "Creating Azure Container Registry..."
	result=`az acr create \
		--output json \
		--name $AZURE_CONTAINER_REGISTRY_NAME \
		--resource-group $MY_RESOURCE_GROUP \
		--sku Basic \
		--admin-enabled true \
		| grep provisioningState | cut -d '"' -f 4`
	if [ "${result}" != "Succeeded" ]; then
		echo "Failed to create a container registry."
		exit 1
	fi
	readonly AZURE_CONTAINER_REGISTRY_PASSWORD=`az acr credential show \
		--output json \
		--name $AZURE_CONTAINER_REGISTRY_NAME \
		| grep "value" | head -1 | cut -d '"' -f 4`
}

build_and_push_Docker_Image () {
	echo "Cloning Dockerfile..."
	git clone "${GITHUB_URL}/${GITHUB_ID}/${GITHUB_DIR}"
	cd $GITHUB_DIR
	echo "RUN /usr/bin/php /var/www/installer/index.php \
		-h ${MYSQL_NAME}.mysql.database.azure.com:${MYSQL_PORT} \
		-u $MYSQL_USER@${MYSQL_NAME} \
		-p $MYSQL_PASSWORD" >> Dockerfile
	echo "Building Docker Image..."
	result=`docker build --tag $DOCKER_IMAGE . \
		| grep "Successfully built"`
	if [ "${result}" = "" ]; then
		echo "Failed to build docker image."
		exit 1
	fi
	docker tag \
		$DOCKER_IMAGE \
		$AZURE_CONTAINER_REGISTRY_NAME.azurecr.io/$DOCKER_IMAGE
	result=`docker login $AZURE_CONTAINER_REGISTRY_NAME.azurecr.io \
		--username $AZURE_CONTAINER_REGISTRY_NAME \
		--password $AZURE_CONTAINER_REGISTRY_PASSWORD`
	if [ "${result}" != "Login Succeeded" ]; then
		echo "Failed to login to Azure Container Registry"
		exit 1
	fi
	docker push $AZURE_CONTAINER_REGISTRY_NAME.azurecr.io/$DOCKER_IMAGE
	cd -
}

create_WebApp () {
	echo  "Creating Azure Web App..."
	az appservice plan create \
		--output json \
		--name $SERVICE_PLAN \
		--resource-group $MY_RESOURCE_GROUP \
		--is-linux
	az webapp create \
		--output json \
		-g $MY_RESOURCE_GROUP \
		-p $SERVICE_PLAN \
		-n $WEB_APP_NAME \
		--runtime "php|5.6"
	az webapp config container set \
		--output json \
		-n $WEB_APP_NAME \
		-g $MY_RESOURCE_GROUP \
		--docker-custom-image-name $DOCKER_IMAGE \
		-r https://$AZURE_CONTAINER_REGISTRY_NAME.azurecr.io \
		-u $AZURE_CONTAINER_REGISTRY_NAME \
		-p $AZURE_CONTAINER_REGISTRY_PASSWORD
}

create_AKS (){
	echo  "Creating Azure Container Service..."
	az provider register \
		--output json \
		-n Microsoft.ContainerService
	az aks create \
		--output json \
		--name $AKS_NAME \
		--resource-group $MY_RESOURCE_GROUP
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
	az aks get-credentials \
		--output json \
		-n $AKS_NAME \
		-g $MY_RESOURCE_GROUP
}

create_MySQL () {
	echo "Creating Azure DB for MySQL..."
	result=`az mysql server create \
		--output json \
		-g $MY_RESOURCE_GROUP \
		--name $MYSQL_NAME \
		--location $LOCATION \
		-u $MYSQL_USER \
		-p $MYSQL_PASSWORD \
		--performance-tier Basic \
		--ssl-enforcement Disabled \
		--compute-units 50 \
		| grep "userVisibleState" | cut -d '"' -f 4`
	if [ "${result}" != "Ready" ]; then
		echo "Failed to create Azure DB for MySQL."
		exit 1
	fi
	az mysql server firewall-rule create \
		--output json \
		-g $MY_RESOURCE_GROUP \
		--server $MYSQL_NAME \
		--name AllowAll \
		--start-ip-address 0.0.0.0 \
		--end-ip-address 255.255.255.255
}

configure_Firewall_Rule () {
	az mysql server firewall-rule delete \
		--output json \
		-g $MY_RESOURCE_GROUP \
		--server $MYSQL_NAME \
		--name AllowAll
	az mysql server firewall-rule create \
		--output json \
		-g $MY_RESOURCE_GROUP \
		--server $MYSQL_NAME \
		--name gallery3 \
		--start-ip-address 0.0.0.0 \
		--end-ip-address 255.255.255.255
}

create_Group

create_MySQL

create_ACR

build_and_push_Docker_Image

create_WebApp
#create_AKS

#configure_Firewall_Rule
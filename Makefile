CLUSTER_NAME = pypi-popular.k8s.local

all: clean build

local.build:
	@python setup.py install

local.clean:
	@echo "Removing dist"
	@rm -rf build dist

docker.build:
	docker build -t philippehachey/pypi-popular-api .

docker.push:
	docker push philippehachey/pypi-popular-api

docker.all: docker.build docker.push

terraform.init:
	@terraform init \
		deployment/

terraform.apply:
	@terraform apply -auto-approve \
		deployment/

terraform.plan:
	@terraform plan \
		deployment/

terraform.all: terraform.init terraform.apply

kops.create.cluster:
	@kops create cluster \
		--zones us-east-1a \
		--out deployment/terraform_k8s_cluster/ \
		--target terraform \
		--name $(CLUSTER_NAME)

kops.update.cluster:
	@kops update cluster \
		--out deployment/terraform_k8s_cluster/ \
		--target terraform \
		--name $(CLUSTER_NAME)

kube.apply.all:
	kubectl apply -f deployment/kubernetes/api-deployment.yml
	kubectl apply -f deployment/kubernetes/api-service.yml
	kubectl apply -f deployment/kubernetes/es-deployment.yml
	kubectl apply -f deployment/kubernetes/route53-mapper.yml

kube.delete.all:
	kubectl delete -f deployment/kubernetes/api-deployment.yml
	kubectl delete -f deployment/kubernetes/api-service.yml
	kubectl delete -f deployment/kubernetes/es-deployment.yml
	kubectl delete -f deployment/kubernetes/route53-mapper.yml

deploy:
	@serverless --stage $(stage) deploy

.PHONY: all

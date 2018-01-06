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

deploy:
	@serverless --stage $(stage) deploy

.PHONY: all

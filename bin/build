#!/bin/bash

set -e

# Configuration
ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
REPOSITORY_NAME="todos/backend-rails"
IMAGE_TAG="${1:-latest}"

# Build Docker image
cd backend-rails
docker build -t ${REPOSITORY_NAME}:${IMAGE_TAG} .
cd ..

# Login to ECR
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}

# Tag and push
docker tag ${REPOSITORY_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${REPOSITORY_NAME}:${IMAGE_TAG}
docker push ${ECR_REGISTRY}/${REPOSITORY_NAME}:${IMAGE_TAG}

echo "Pushed ${ECR_REGISTRY}/${REPOSITORY_NAME}:${IMAGE_TAG}"
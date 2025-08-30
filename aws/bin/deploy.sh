#!/bin/bash

ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
REPOSITORY_NAME="todos/backend-rails"
IMAGE_TAG="${1:-latest}"

# Log into ECR --------
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
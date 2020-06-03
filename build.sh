#!/usr/bin/env bash
#-------------------------------------------------------------------------------
set -e

ZIMAGI_BASE_REGISTRY="${ZIMAGI_BASE_REGISTRY:-registry.hub.docker.com}"
ZIMAGI_BASE_IMAGE="${ZIMAGI_BASE_IMAGE:-zimagi/zimagi}"

ZIMAGI_REGISTRY="${ZIMAGI_REGISTRY:-registry.hub.docker.com}"
#-------------------------------------------------------------------------------

echo "Fetching upstream Zimagi tags"
ZIMAGI_TAGS="$(wget -q "https://${ZIMAGI_BASE_REGISTRY}/v1/repositories/${ZIMAGI_BASE_IMAGE}/tags" -O - | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n' | awk -F: '{print $3}')"

echo "Logging into DockerHub"
echo "$ZIMAGI_REGISTRY_PASSWORD" | docker login --username "$ZIMAGI_REGISTRY_USER" --password-stdin "${ZIMAGI_REGISTRY}"

for TAG in $ZIMAGI_TAGS
do
    echo "Building Zimagi tag: ${TAG}"
    docker build \
        --build-arg ZIMAGI_VERSION="${TAG}" \
        --build-arg ZIMAGI_CA_KEY \
        --build-arg ZIMAGI_CA_CERT \
        --build-arg ZIMAGI_KEY \
        --build-arg ZIMAGI_CERT \
        --file "Dockerfile" \
        --tag "${ZIMAGI_REGISTRY}/${ZIMAGI_IMAGE}:${TAG}" .

    echo "Pushing Zimagi tag: ${TAG}"
    docker push "${ZIMAGI_REGISTRY}/${ZIMAGI_IMAGE}:${TAG}"
done

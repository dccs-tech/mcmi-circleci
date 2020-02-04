#!/usr/bin/env bash
#-------------------------------------------------------------------------------
set -e

MCMI_BASE_REGISTRY="${MCMI_BASE_REGISTRY:-registry.hub.docker.com}"
MCMI_BASE_IMAGE="${MCMI_BASE_IMAGE:-mcmi/mcmi}"

MCMI_REGISTRY="${MCMI_REGISTRY:-registry.hub.docker.com}"
#-------------------------------------------------------------------------------

echo "Fetching upstream MCMI tags"
MCMI_TAGS="$(wget -q "https://${MCMI_BASE_REGISTRY}/v1/repositories/${MCMI_BASE_IMAGE}/tags" -O - | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n' | awk -F: '{print $3}')"

echo "Logging into DockerHub"
echo "$MCMI_REGISTRY_PASSWORD" | docker login --username "$MCMI_REGISTRY_USER" --password-stdin "${MCMI_REGISTRY}"

for TAG in $MCMI_TAGS
do
    echo "Building MCMI tag: ${TAG}"
    docker build \
        --build-arg MCMI_VERSION="${TAG}" \
        --build-arg MCMI_CA_KEY \
        --build-arg MCMI_CA_CERT \
        --build-arg MCMI_KEY \
        --build-arg MCMI_CERT \
        --file "Dockerfile" \
        --tag "${MCMI_IMAGE}:${TAG}" .

    echo "Pushing MCMI tag: ${TAG}"
    docker push "${MCMI_REGISTRY}/${MCMI_IMAGE}:${TAG}"
done

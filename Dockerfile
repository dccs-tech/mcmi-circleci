ARG ZIMAGI_VERSION=latest
FROM zimagi/zimagi:${ZIMAGI_VERSION}
#
#====================================================================
# OS environment configuration
#
ARG ZIMAGI_CA_KEY
ARG ZIMAGI_CA_CERT
ARG ZIMAGI_KEY
ARG ZIMAGI_CERT

RUN store-key /etc/ssl/private/zimagi-ca.key "${ZIMAGI_CA_KEY}"
RUN store-cert /usr/local/share/ca-certificates/zimagi-ca.crt "${ZIMAGI_CA_CERT}"
RUN update-ca-certificates

RUN store-key /etc/ssl/private/zimagi.key "${ZIMAGI_KEY}"
RUN store-cert /etc/ssl/certs/zimagi.crt "${ZIMAGI_CERT}"

ARG ZIMAGI_DATA_KEY
RUN echo "${ZIMAGI_DATA_KEY}" > "/var/local/keys/data.key"

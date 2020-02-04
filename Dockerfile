ARG MCMI_VERSION=latest
FROM mcmi/mcmi:${MCMI_VERSION}
#
#====================================================================
# OS environment configuration
#
ARG MCMI_CA_KEY
ARG MCMI_CA_CERT
ARG MCMI_KEY
ARG MCMI_CERT

RUN store-key /etc/ssl/private/mcmi-ca.key "${MCMI_CA_KEY}"
RUN store-cert /usr/local/share/ca-certificates/mcmi-ca.crt "${MCMI_CA_CERT}"
RUN update-ca-certificates

RUN store-key /etc/ssl/private/mcmi.key "${MCMI_KEY}"
RUN store-cert /etc/ssl/certs/mcmi.crt "${MCMI_CERT}"

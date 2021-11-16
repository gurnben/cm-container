FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

# Set the working directory (to better tolerate all of the clis dotfiles)
ENV HOME=/tmp
WORKDIR $HOME

# Install necessary tools
RUN microdnf update -y && microdnf install -y tar gzip curl jq wget

# Install oc/kubectl
RUN curl -sLO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz -o openshift-client-linux.tar.gz && \
    tar xzf openshift-client-linux.tar.gz && chmod +x oc && mv oc /usr/local/bin/oc && \
    chmod +x kubectl && mv kubectl /usr/local/bin/kubectl && rm openshift-client-linux.tar.gz

# Install the latest version of cm
RUN curl -s https://api.github.com/repos/open-cluster-management/cm-cli/releases/latest \
  | jq -r '.assets[] | select(.browser_download_url | contains("linux_amd64")) | .browser_download_url' \
  | wget -qi - \
  && tar xzf cm_linux_amd64.tar.gz && mv cm /usr/local/bin/cm && rm cm_linux_amd64.tar.gz

FROM homebrew/brew:latest

RUN brew install yq

USER root
RUN apt-get update

COPY packages.yaml /tmp/packages.yaml

RUN apt-get update && \
    yq eval '.apt-packages[]' /tmp/packages.yaml | xargs apt-get install -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER linuxbrew

RUN yq eval '.brew-packages[]' /tmp/packages.yaml | xargs -n1 brew install
RUN tldr -u

USER root
WORKDIR /root

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN yq eval '.code-server-packages[]' /tmp/packages.yaml | while read extension; do \
    code-server --install-extension "$extension"; \
    done

ENV PATH=/root/.local/bin:${PATH}

RUN yq eval '.uv-tool-packages[]' /tmp/packages.yaml | while read package; do \
    uv tool install "$package"; \
    done

RUN uv pip install pynvim --system
RUN npm i -g pm2

COPY ./.bashrc /root/.bashrc
COPY startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

ENV PM2_HOME /root/.pm2

EXPOSE 8023-8024

# PM2 will take care of running the applications
CMD ["/root/startup.sh"]
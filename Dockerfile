FROM node:10-alpine
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV
RUN npm i npm@latest -g
RUN mkdir /opt/node_app && chown node:node /opt/node_app
WORKDIR /opt/node_app
USER node
COPY package.json package-lock.json* ./
RUN npm install --no-optional && npm cache clean --force
ENV PATH /opt/node_app/node_modules/.bin:$PATH
WORKDIR /opt/node_app/app
COPY . .

# Jobber
USER root
# Make jobber dirs for node user
ENV USERID 1000
RUN mkdir -p "/var/jobber/${USERID}" && \
    chown -R node:node "/var/jobber/${USERID}"
# Install Jobber
ENV JOBBER_VERSION 1.4.0
ENV JOBBER_SHA256 37a96591e2c28494ef009d900a4c680c4fbd3c82bf4e6de3f70c6ad451e45867
RUN wget -O /tmp/jobber.apk "https://github.com/dshearer/jobber/releases/download/v${JOBBER_VERSION}/jobber-${JOBBER_VERSION}-r0.apk" && \
    echo "${JOBBER_SHA256} */tmp/jobber.apk" | sha256sum -c && \
# --no-scripts is needed b/c the post-install scripts don't work in Docker
    apk add --no-network --no-scripts --allow-untrusted /tmp/jobber.apk && \
    rm /tmp/jobber.apk
# Add Jobfile
COPY --chown=node:node jobfile /home/node/.jobber
RUN chmod 0600 /home/node/.jobber
CMD ["/usr/libexec/jobberrunner", "-u", "/var/jobber/1000/cmd.sock", "/home/node/.jobber"]

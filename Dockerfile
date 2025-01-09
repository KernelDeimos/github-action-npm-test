# Dockerfile copied from Puter - minimal reproduction of a bug is in progress

# Build stage
FROM node:22-alpine AS build

# Install build dependencies
RUN apk add --no-cache git python3 make g++ \
    && ln -sf /usr/bin/python3 /usr/bin/python

# Set up working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Copy the source files
COPY . .

# Install mocha
RUN npm install -g mocha

# Install node modules
RUN npm cache clean --force && \
    for i in 1 2 3; do \
        npm ci && break || \
        if [ $i -lt 3 ]; then \
            sleep 15; \
        else \
            exit 1; \
        fi; \
    done

# Production stage
FROM node:22-alpine

# Set labels
LABEL repo="https://github.com/KernelDeimos/github-action-npm-test"
LABEL license="AGPL-3.0,https://github.com/KernelDeimos/github-action-npm-test/blob/main/LICENSE"
LABEL version="1.0.0"

# Install git (required by Puter to check version)
RUN apk add --no-cache git

# Set up working directory
RUN mkdir -p /opt/test/app
WORKDIR /opt/test/app

# Copy built artifacts and necessary files from the build stage
COPY --from=build /app/node_modules ./node_modules
COPY . .

# Set permissions
RUN chown -R node:node /opt/test/app
USER node

EXPOSE 4100

CMD ["npm", "start"]

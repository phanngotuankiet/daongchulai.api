FROM node:20-alpine

WORKDIR /app

# Install Hasura CLI
RUN apk add --no-cache curl bash
RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 4002

CMD ["node", "server.js"]
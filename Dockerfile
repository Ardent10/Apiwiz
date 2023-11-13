# Stage 1: Build the React Frontend
FROM node:16-alpine as build-client

WORKDIR /apiwiz/wizdesk/client

COPY wizdesk/client/package*.json ./
RUN npm install

COPY wizdesk/client/ .
RUN npm run build

# Stage 2: Build the Node.js Backend
FROM node:16-alpine as build-server

WORKDIR /apiwiz/wizdesk/server

COPY wizdesk/server/package*.json ./
RUN npm install

COPY wizdesk/server/ .

# Stage 3: Final Image with Nginx, serving the React build, and running the Node.js server
FROM nginx:alpine

# Copy the React build from the build-client stage
COPY --from=build-client /apiwiz/wizdesk/client/build /usr/share/nginx/html

# Copy the Node.js server from the build-server stage
COPY --from=build-server /apiwiz/wizdesk/server /usr/src/apiwiz

# Expose ports
EXPOSE 80
EXPOSE 3000  # Updated to match the frontend port

# Command to start the Node.js server (customize as needed)
CMD ["npm", "start"]
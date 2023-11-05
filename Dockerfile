# Multi-stage
# 1) Node image for building frontend assets
# 2) nginx stage to serve frontend assets

# Name the node stage "builder"
FROM node:18-alpine as builder
# Set working directory
WORKDIR /app
# Copy all files from current directory to working dir in image
COPY . .
# Install dependencies
RUN npm install
# Build the React app for production
RUN npm run build
# nginx state for serving content
FROM nginx:stable-alpine
# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
# Copy static assets from builder stage
COPY --from=builder /app/build .
# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]

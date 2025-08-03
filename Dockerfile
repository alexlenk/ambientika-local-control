#Build stage
FROM node:22-alpine AS build

WORKDIR /app

# Install build dependencies for native modules like sqlite3
RUN apk add --no-cache python3 py3-setuptools make g++ && \
    npm config set cache-max 0 && \
    npm config set fetch-retries 3 && \
    npm config set fetch-retry-factor 10 && \
    npm config set fetch-retry-mintimeout 10000 && \
    npm config set fetch-retry-maxtimeout 60000

COPY package*.json .

# Use npm ci for faster, reliable builds
RUN npm ci --verbose

COPY . .

RUN npm run build

#Production stage - Use Node.js Alpine for GitHub Actions
FROM node:22-alpine AS production

WORKDIR /app

# Install runtime dependencies for native modules like sqlite3
RUN apk add --no-cache python3 py3-setuptools make g++ && \
    npm config set cache-max 0

COPY package*.json .

# Use npm ci with production flag for faster installs
RUN npm ci --omit=dev --verbose

COPY --from=build /app/dist ./dist
COPY .env ./

CMD ["node", "dist/index.js"]

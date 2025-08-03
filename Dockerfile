#Build stage
FROM node:22-alpine AS build

WORKDIR /app

# Install build dependencies for native modules like sqlite3
RUN apk add --no-cache python3 py3-setuptools make g++

COPY package*.json .

RUN npm install

COPY . .

RUN npm run build

#Production stage - Use Node.js Alpine for GitHub Actions
FROM node:22-alpine AS production

WORKDIR /app

# Install runtime dependencies for native modules like sqlite3
RUN apk add --no-cache python3 py3-setuptools make g++

COPY package*.json .

RUN npm ci --only=production

COPY --from=build /app/dist ./dist
COPY .env ./

CMD ["node", "dist/index.js"]

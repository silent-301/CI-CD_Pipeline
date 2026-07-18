# Stage 1: Install dependencies
FROM node:20-alpine AS deps

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Stage 2: Production image
FROM node:20-alpine

WORKDIR /app

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy dependencies and source code
COPY --from=deps /app/node_modules ./node_modules
COPY package.json ./
COPY index.js ./

# Switch to non-root user
USER appuser

EXPOSE 3000

CMD ["node", "index.js"]

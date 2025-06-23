# Step 1: Use environment variable during build
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Inject build-time environment variables
ENV NEXT_PUBLIC_APP_URL=production

RUN npm run build

# Step 2: Runtime image
FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

ENV PORT=8080
EXPOSE 8080
CMD ["npm", "start"]
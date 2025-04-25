FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build
RUN npm install -g serve

# runtime
FROM node:20-alpine

WORKDIR /app
COPY --from=builder /app/out ./out
COPY --from=builder /usr/local/bin/serve /usr/local/bin/serve

EXPOSE 3000
CMD ["serve", "-s", "out", "-l", "3000"]

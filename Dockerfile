FROM node:22-slim AS base
WORKDIR /app
COPY package.json .
COPY package-lock.json* .
RUN npm ci

FROM node:22-slim AS base_prod
WORKDIR /app

FROM node:22-slim AS builder
WORKDIR /app
COPY package.json .
COPY package-lock.json* .
COPY . .
RUN npm ci
RUN npm run build

FROM base AS production
WORKDIR /app
COPY --from=builder /app/build ./app/build
RUN npm ci --omit dev

CMD node --env-file=.env build

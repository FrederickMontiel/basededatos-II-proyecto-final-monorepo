FROM node:18-alpine

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app

# Install dependencies
COPY package*.json pnpm-lock.yaml* ./
RUN pnpm install --no-frozen-lockfile

# Copy source code
COPY . .

# Build
RUN pnpm run build

EXPOSE 3000

CMD ["pnpm", "run", "start:dev"]

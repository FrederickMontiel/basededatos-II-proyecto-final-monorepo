FROM node:18-alpine

# Install pnpm
RUN npm install -g pnpm @angular/cli

WORKDIR /app

# Install dependencies
COPY package*.json pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile

# Copy source code
COPY . .

EXPOSE 4200

CMD ["ng", "serve", "--host", "0.0.0.0", "--poll=2000"]

FROM node:18-alpine

WORKDIR /app

# Install Angular CLI
RUN npm install -g @angular/cli

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

EXPOSE 4200

CMD ["ng", "serve", "--host", "0.0.0.0", "--poll=2000"]

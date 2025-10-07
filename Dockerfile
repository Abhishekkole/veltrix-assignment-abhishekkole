FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
RUN npm install -g pm2
RUN mkdir -p logs
EXPOSE 3000
CMD ["pm2-runtime", "start", "ecosystem.config.js"]
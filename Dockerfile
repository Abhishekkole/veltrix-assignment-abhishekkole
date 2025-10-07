FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
RUN npm install -g pm2
RUN mkdir -p /app/logs
EXPOSE 3000
EXPOSE 4000
CMD ["pm2-runtime", "start", "ecosystem.config.js"]

module.exports = {
  apps: [
    {
      name: "app",
      script: "./dist/app.js",
      watch: false,
      env: {
        NODE_ENV: "production",
        INFURA_URL: "https://mainnet.infura.io/v3/26810f4b20bb4e44af67da7f4ae77b70"
      },
      error_file: "./logs/app-error.log",
      out_file: "./logs/app-out.log",
      log_date_format: "YYYY-MM-DD HH:mm Z"
    },
    {
      name: "api",
      script: "./dist/api.js",
      watch: false,
      env: {
        NODE_ENV: "production",
        INFURA_URL: "https://mainnet.infura.io/v3/26810f4b20bb4e44af67da7f4ae77b70"
      },
      error_file: "./logs/api-error.log",
      out_file: "./logs/api-out.log",
      log_date_format: "YYYY-MM-DD HH:mm Z"
    }
  ]
};

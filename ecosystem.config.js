module.exports = {
  apps: [
    {
      name: "app",
      script: "app.js",
      watch: false,
      env: {
        NODE_ENV: "production"
      },
      error_file: "./logs/app-error.log",
      out_file: "./logs/app-out.log",
      log_date_format: "YYYY-MM-DD HH:mm Z"
    },
    {
      name: "api",
      script: "api.js",
      watch: false,
      env: {
        NODE_ENV: "production"
      },
      error_file: "./logs/api-error.log",
      out_file: "./logs/api-out.log",
      log_date_format: "YYYY-MM-DD HH:mm Z"
    }
  ]
};

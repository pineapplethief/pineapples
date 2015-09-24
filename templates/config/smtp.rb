SMTP_SETTINGS = {
  address: ENV.fetch('SMTP_ADDRESS'), # example: "smtp.sendgrid.net"
  port: ENV.fetch('SMTP_PORT', 587),
  authentication: :plain,
  domain: ENV.fetch('SMTP_DOMAIN'), # example: "heroku.com"
  enable_starttls_auto: true,
  user_name: ENV.fetch('SMTP_USERNAME'),
  password: ENV.fetch('SMTP_PASSWORD')
}

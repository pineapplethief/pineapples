SMTP_SETTINGS = {
  authentication: ENV.fetch('SMTP_AUTHENTICATION', :plain).to_sym,
  enable_starttls_auto:  ENV.fetch('SMTP_STARTTLS', false),

  address: ENV.fetch('SMTP_ADDRESS'), # example: "smtp.sendgrid.net"
  domain: ENV.fetch('SMTP_DOMAIN'), # example: "heroku.com"
  port: ENV.fetch('SMTP_PORT', 587),

  user_name: ENV.fetch('SMTP_USERNAME'),
  password: ENV.fetch('SMTP_PASSWORD')
}

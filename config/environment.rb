# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: "apikey", # This is the string literal 'apikey', NOT the ID of your API key
  password: Rails.application.credentials.dig(:sendgrid_api_secret), # This is the secret sendgrid API key which was issued during API key creation
  domain: "leisuresphere-19144872.koyeb.app",
  address: "smtp.sendgrid.net",
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}

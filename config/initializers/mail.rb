ActionMailer::Base.default_url_options = { protocol: "https", host: "d897b06322f248eb81db05207789bfca.vfs.cloud9.us-east-1.amazonaws.com" }
if Rails.env.production?
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.delivery_method = :smtp;
  ActionMailer::Base.smtp_settings = {
    address: "smtp.gmail.com",
    domain: "gmail.com",
    port: 587,
    user_name: ENV["EMAIL_ADDRESS"],
    password: ENV["EMAIL_PASSWORD"],
    authentication: "plain",
    enable_starttls_auto: true
  }
elsif Rails.env.development?
  ActionMailer::Base.delivery_method = :letter_opener
else
  ActionMailer::Base.default_url_options = { host: "localhost", port: 3000 }
  ActionMailer::Base.delivery_method = :test
end
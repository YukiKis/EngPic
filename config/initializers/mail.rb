if Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp;
  ActionMailer::Base.smtip_settings = {
    address: "smtp.gmail.com",
    domain: "gmail.com",
    port: 587,
    user_name: ENV["EMAIL_ADDRESS"],
    password: ENV["EMAIL_PASSWORD"],
    authentication: "plain",
    enable_startles_auto: true
  }
elsif Rails.env.development?
  ActionMailer::Base.delivery_method = :letter_opener
else
  ActionMailer::Base.delivery_method = :test
end
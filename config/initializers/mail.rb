if Rails.env.production?
  mail = ENV["EMAIL_ADDRESS"]
  password = ENV["EMAIL_PASSWORD"]
  ActionMailer::Base.default_url_options = { protocol: "http", host: ENV["IP_ADDRESS"] } #ec2がhttps非対応のためhttpで指定
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.delivery_method = :smtp;
  ActionMailer::Base.smtp_settings = {
    address: "smtp.gmail.com",
    domain: "gmail.com",
    port: 587,
    user_name: mail,
    password: password,
    authentication: "plain",
    enable_starttls_auto: true
  }
elsif Rails.env.development?
  ActionMailer::Base.default_url_options = { protocol: "https", host: "bc93f3ed1d1d4878a70efa58838af9ed.vfs.cloud9.us-east-1.amazonaws.com" }
  ActionMailer::Base.delivery_method = :letter_opener
else
  ActionMailer::Base.default_url_options = { protocol: "https", host: "bc93f3ed1d1d4878a70efa58838af9ed.vfs.cloud9.us-east-1.amazonaws.com" }
  ActionMailer::Base.delivery_method = :test
end
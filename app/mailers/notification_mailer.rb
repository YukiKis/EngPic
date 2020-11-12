class NotificationMailer < ApplicationMailer
  default from: "yuki@encpic.com"
  
  def send_notify_mail(user)
    @user = user
    mail(
      to: @user.email,
      subject: "★本日の追記件数★"
      )
  end
end

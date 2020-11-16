class NotificationMailer < ApplicationMailer
  default from: "yuki@engpic.com"
  
  def send_notify_mail(user)
    @user = user
    @count = @user.words.today.count 
    mail(
      to: @user.email,
      subject: "★本日の追記件数★"
      )
  end
  
  def send_monthly_mail(user)
    @user = user
    @count = @user.words.where("created_at >= ?", Date.today.beginning_of_month).count
    mail(
      to: @user.email,
      subject: "★今月の追加件数★"
      )
  end
end

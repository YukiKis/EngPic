class Batch::SendMonthlyEmail
  def self.send_monthly_mail
    User.all.each do |u|
     NotificationMailer.send_monthly_mail(u).deliver_now
    end
    p "全ユーザーにメールが送信されました。"
  end
end


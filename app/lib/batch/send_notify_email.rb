class Batch::SendNotifyEmail
  def self.send_notify_mail
    User.active.each do |u|
      NotificationMailer.send_notify_mail(u).deliver_now
    end
    p "全ユーザーにメールの送信が完了しました。"
  end
end
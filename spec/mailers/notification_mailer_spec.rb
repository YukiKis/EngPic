require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
	let(:user1){ create(:user1) }
	
	after(:all) do
	  ActionMailer::Base.deliveries.clear
  end
  
  context "about notify_email" do
    before do
      NotificationMailer.send_notify_mail(user1).deliver_now
    	@mail = ActionMailer::Base.deliveries.last
    end
    it "has right subject" do
    	expect(@mail.subject).to eq "★本日の追記件数★"
    end
    it "has right mailer email" do
      expect(@mail.from.first).to eq "yuki@engpic.com"
    end
    it "has right destination" do
      expect(@mail.to.first).to eq user1.email
    end
    it "has right content" do
      name = user1.name
      expect(@mail.text_part.body.to_s).to match(/#{name}様の本日の追記件数/)
      expect(@mail.html_part.body.to_s).to match(/#{name}様の本日の追記件数/)
    end
  end
  
  context "about monthly_mail" do
    before do
      NotificationMailer.send_monthly_mail(user1).deliver_now
      @mail  = ActionMailer::Base.deliveries.last
    end
    it "has right subject" do
      expect(@mail.subject).to eq "★今月の追加件数★"
    end
    it "has right mailer email" do
      expect(@mail.from.first).to eq "yuki@engpic.com"
    end
    it "has right destination" do
      expect(@mail.to.first).to eq user1.email
    end
    it "has right content" do
      name = user1.name
      expect(@mail.text_part.body.to_s).to match(/#{name}様の今月の追記件数/)
      expect(@mail.html_part.body.to_s).to match(/#{name}様の今月の追記件数/)
    end
  end
end

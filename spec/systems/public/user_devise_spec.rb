require "rails_helper"

RSpec.describe "devise-user", type: :system do
  after(:all) do
    ActionMailer::Base.deliveries.clear
  end
  context "on registration_page" do
    let(:user1){ build(:user1) }
    before do
      visit new_user_registration_path
    end
    it "has a field for name" do
      expect(page).to have_content "名前"
      expect(page).to have_field "user[name]"
    end
    it "has a field for introduction" do
      expect(page).to have_content "紹介文"
      expect(page).to have_field "user[introduction]"
    end
    it "has a field for email" do
      expect(page).to have_content "メールアドレス"
      expect(page).to have_field "user[email]"
    end
    it "has a field for password" do
      expect(page).to have_content "パスワード"
      expect(page).to have_field "user[password]"
    end
    it "has a field for password_confirmation" do
      expect(page).to have_content "パスワード（確認）"
      expect(page).to have_field "user[password_confirmation]" 
    end
    it "has a button to submit" do
      expect(page).to have_button "登録"
    end
    it "succeeds to make a new user" do
      fill_in "user[name]", with: user1.name
      fill_in "user[introduction]", with: user1.introduction
      fill_in "user[email]", with: user1.email
      fill_in "user[password]", with: user1.password
      fill_in "user[password_confirmation]", with: user1.password_confirmation
      click_button "登録"
      expect(current_path).to eq user_path(User.find_by(email: "yuki@com"))
      expect(page).to have_content "登録出来ました"
    end
    it "fails to make a new user" do
      click_button "登録"
      expect(page).to have_content "エラー"
    end
    it "fails to make a new user with already registered email" do
      fill_in "user[name]", with: user1.name
      fill_in "user[introduction]", with: user1.introduction
      fill_in "user[email]", with: user1.email
      fill_in "user[password]", with: user1.password
      fill_in "user[password_confirmation]", with: user1.password_confirmation
      click_button "登録"    
      click_link "Sign out"
      click_link "Register"
      fill_in "user[email]", with: user1.email
      click_button "登録"
      expect(page).to have_content "既に登録済み"
    end
  end
  context "on session_page" do
    let(:user1){ create(:user1) }
    before do 
      visit new_user_session_path
    end
    it "has field for email" do
      expect(page).to have_content "メールアドレス"
      expect(page).to have_field "user[email]"
    end
    it "has field for password" do
      expect(page).to have_content "パスワード"
      expect(page).to have_field "user[password]"
    end
    it "has button to login" do
      expect(page).to have_button "Log in"
    end
    it "has link to sigu up" do
      expect(page).to have_link "Sign up", href: new_user_registration_path
    end
    it "has link to change password" do
      expect(page).to have_link "Forget Password", href: new_user_password_path
    end
    it "succeeds to login" do
      fill_in "user[email]", with: user1.email
      fill_in "user[password]", with: user1.password
      click_button "Log in"
      expect(current_path).to eq user_path(User.find_by(email: "yuki@com"))
      expect(page).to have_content "ログインしました"
    end
    it "fails to login" do
      click_button "Log in"
      expect(page).to have_content "違います"
    end
    it "fails to login if user is not active" do
      user1.is_active = false
      user1.save
      visit current_path
      fill_in "user[email]", with: user1.email
      fill_in "user[password]", with: user1.password
      click_button "Log in"
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content "退会済み"
    end
  end
  
  context "on password_page" do
    let(:user1){ create(:user1) }
    before do
      visit new_user_password_path
    end
    it "has field for email" do
      expect(page).to have_field "user[email]"
    end
    it "has button to send an email" do
      expect(page).to have_button "送信"
    end
    it "has link back to login" do
      expect(page).to have_link "Log in", href: new_user_session_path
    end
    it "succeeds to send an email" do
      fill_in "user[email]", with: user1.email
      expect{ click_button "送信" }.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end
    it "fails to send an email" do
      click_button "送信"
      expect(page).to have_content "登録されておりません"
    end
  end
  
  context "on content of email of password-reset" do
    @path = "/users/password/edit?reset_password_token=.*/"
    let(:user1){ create(:user1) }
    let(:sent_mail){ ActionMailer::Base.deliveries.last }
    before do
      visit new_user_password_path
      fill_in "user[email]", with: user1.email
      click_button "送信"
    end
    it "has correct information" do
      expect(sent_mail.body).to have_content user1.email
      expect(sent_mail.body).to match(/#{ @path }/)
    end
  end
end
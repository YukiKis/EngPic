require "rails_helper"

RSpec.describe "devise-user", type: :system do
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
      expect(page).to have_button "Sign up"
    end
    it "succeeds to make a new user" do
      fill_in "user[name]", with: user1.name
      fill_in "user[introduction]", with: user1.introduction
      fill_in "user[email]", with: user1.email
      fill_in "user[password]", with: user1.password
      fill_in "user[password_confirmation]", with: user1.password_confirmation
      click_button "Sign up"
      expect(current_path).to eq user_path(User.find_by(email: "yuki@com"))
      expect(page).to have_content "登録出来ました"
    end
    it "fails to make a new user" do
      click_button "Sign up"
      expect(page).to have_content "エラー"
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
    it "succeeds to login" do
      fill_in "user[email]", with: user1.email
      fill_in "user[password]", with: user1.password
      click_button "Sign in"
      expect(current_path).to eq user_path(User.find_by(email: "yuki@com"))
      expect(page).to have_content "ログインしました"
    end
    it "fails to login" do
      click_button "Sign in"
      expect(page).to have_content "違います"
    end
  end
end
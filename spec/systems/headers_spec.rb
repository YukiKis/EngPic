require "rails_helper"

RSpec.describe "header", type: :system do
  let(:user1){ create(:user1) }
  let(:admin1){ create(:admin1) }
  context "when not logged in" do
    before do
      visit root_path
    end
    it "has 'LOGO' for top page" do
      expect(page).to have_link "EngPic", href: root_path
    end
    it "has 'HOME' for top page" do
      expect(page).to have_link "Home", href: root_path
    end
    it "has 'About' for about page" do
      expect(page).to have_link "About", href: about_path
    end
    it "has 'Register' for new_user_registration page" do
      expect(page).to have_link "Register", href: new_user_registration_path
    end
    it "has 'Log in' for new_user_session_page" do
      expect(page).to have_link "Log in", href: new_user_session_path
    end
  end
  
  context "when logged in as user" do
    before do
      visit new_user_session_path
      fill_in "user[email]", with: user1.email
      fill_in "user[password]", with: user1.password
      click_button "Log in"
    end
    it "has 'EngPic' for top page" do
      expect(page).to have_link "EngPic", href: root_path
    end
    it "has 'MyPage' for own show page" do
      expect(page).to have_link "MyPage", href: user_path(user1) 
    end
    it "has 'Users' for users-index page" do
      expect(page).to have_link "Users", href: users_path
    end
    it "has 'Words' for words-index page" do
      expect(page).to have_link "Words", href: words_path
    end
    it "has 'MyDictionary' for dictionary-show page" do
      expect(page).to have_link "Dictionary", href: dictionary_path
    end
    it "has 'SignOut' for logout" do
      expect(page).to have_link "Sign out", href: destroy_user_session_path
    end
  end
  
  context "when logged in as admin" do
    before do
      visit new_admin_session_path
      fill_in "admin[email]", with: admin1.email
      fill_in "admin[password]", with: admin1.password
      click_button "Log in"
    end
    it "has 'EngPic' for admin_top page" do
      expect(page).to have_link "EngPic", href: admin_top_path
    end
    it "has 'Home' for admin_top page" do
      expect(page).to have_link "Home", href: admin_top_path
    end
    it "has 'Users' for admin_user_index page" do
      expect(page).to have_link "Users", href: admin_users_path 
    end
    it "has 'Words' for admin_words_index page" do
      expect(page).to have_link "Words", href: admin_words_path
    end
    it "has 'Sign out' for logout" do
      expect(page).to have_link "Sign out", href: destroy_admin_session_path
    end
  end
end
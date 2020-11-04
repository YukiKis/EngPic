require "rails_helper"

RSpec.describe "header", type: :system do
  let(:user1){ create(:user1) }
  context "when not logged in" do
    before do
      visit root_path
    end
    it "has 'LOGO' for top page" do
      expect(page).to have_link "LOGO", href: root_path
    end
    it "has 'HOME' for top page" do
      expect(page).to have_link "Home", href: root_path
    end
    it "has 'About' for about page" do
      expect(page).to have_link "About", href: about_path
    end
    it "has 'HowTo' for howto page" do
      expect(page).to have_link "HowTo", href: howto_path
    end
    it "has 'SignUp' for new_user_registration page" do
      expect(page).to have_link "SignUp", href: new_user_registration_path
    end
    it "has 'SignIn' for new_user_session_page" do
      expect(page).to have_link "SignIn", href: new_user_session_path
    end
  end
  context "when logged in as user" do
    before do
      visit new_user_session_path
      fill_in "user[email]", with: user1.email
      fill_in "user[password]", with: user1.password
      click_button "Sign in"
    end
    it "has 'LOGO' for top page" do
      expect(page).to have_link "LOGO", href: root_path
    end
    it "has 'Users' for users-index page" do
      expect(page).to have_link "Users", href: users_path
    end
    it "has 'Words' for words-index page" do
      expect(page).to have_link "Words", href: words_path
    end
    it "has 'MyDictionary' for dictionary-show page" do
      expect(page).to have_link "MyDictionary", href: dictionary_path
    end
    it "has 'SignOut' for logout" do
      expect(page).to have_link "SignOut", href: destroy_user_session_path
    end
  end

end
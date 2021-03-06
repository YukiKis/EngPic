require "rails_helper"

RSpec.describe "admin-users page", type: :system do
  let(:admin1){ create(:admin1) }
  let!(:user1){ create(:user1) }
  let!(:user2){ create(:user2) }
  let!(:word1){ create(:word1, user: user1) }
  let!(:word2){ create(:word2, user: user1) }
  before do
    visit new_admin_session_path
    fill_in "admin[email]", with: admin1.email
    fill_in "admin[password]", with: admin1.password
    click_button "Log in"
  end
  
  context "on index page" do
    before do 
      visit admin_users_path 
    end
    it "has search_field for user" do
      expect(page).to have_field "q[name_start]"
    end
    it "has total count of users" do
      expect(page).to have_content User.all.count
    end
    it "has users-table" do
      User.all.each do |user|
        expect(page).to have_css "#user-image-#{ user.id }"
        expect(page).to have_link user.name, href: admin_user_path(user)
        expect(page).to have_content user.words.count
      end
    end
    it "has image thumbnails" do
      User.all.each do |user|
        user.words.sample(5).each do |word|
          expect(page).to have_css "#word-image-#{ word.id }"
          expect(page).to have_link "", href: admin_word_path(word)
        end
      end
    end
    it "has red label if the user is not active" do
      user1.is_active = false
      user1.save
      visit current_path
      User.all.each do |user|
        unless user.is_active
          expect(page).to have_css "#user-info-#{ user.id }.inactive"
        end
      end
    end
    it "can search by name" do
      fill_in "q[name_start]", with: user1.name
      click_button "検索"
      expect(current_path).to eq search_admin_users_path
      users = User.where("name = ?", "%#{ user1.name }")
      users.each do |user| 
        expect(page).to have_link user.name, href: admin_user_path
      end
    end
  end
  
  context "on show page" do
    before do
      visit admin_user_path(user1)
    end
    it "has user name" do
      expect(page).to have_content user1.name
    end
    it "has user-image" do
      expect(page).to have_css ".image"
    end
    it "has introduction" do
      expect(page).to have_content user1.introduction
    end
    it "has email" do
      expect(page).to have_content user1.email
    end
    it "has '在籍' if the user is active" do
      expect(page).to have_content "在籍"
    end
    it "has '退会' if the user is not active" do
      user1.is_active = false
      user1.save
      visit current_path
      expect(page).to have_content "退会"
    end
    it "has user-words" do
      user1.words[0..19].each do |word|
        expect(page).to have_link "", href: admin_word_path(word)
        expect(page).to have_css "#word-image-#{ word.id }"
        expect(page).to have_content word.name
      end
    end
    it "has button to edit" do
      expect(page).to have_link "編集", href: edit_admin_user_path(user1)
    end
    it "has button to dictionary_page" do
      expect(page).to have_link "辞書", href: admin_user_dictionary_path(user1)
    end
  end
  
  context "on edit page" do
    before do
      visit edit_admin_user_path(user1)
    end
    it "has name_field" do
      expect(page).to have_field "user[name]", with: user1.name
    end
    it "has introduction_field" do
      expect(page).to have_field "user[introduction]", with: user1.introduction
    end
    it "has email_field" do
      expect(page).to have_field "user[email]", with: user1.email
    end
    it "has status button" do
      expect(page).to have_field "在籍"
      expect(page).to have_field "退会"
    end
    it "has button to update" do
      expect(page).to have_button "Update"
    end
    it "has button to back" do
      expect(page).to have_link "Back", href: admin_user_path(user1)
    end
    it "succeeds to update" do
      attach_file "user[image]", "#{ Rails.root }/spec/factories/noimage.jpg"
      fill_in "user[name]", with: "kiyu"
      fill_in "user[introduction]", with: "Good morning!"
      fill_in "user[email]", with: "kiyu@com"
      click_button "Update"
      expect(current_path).to eq admin_user_path(user1)
      expect(page).to have_content "kiyu"
      expect(page).to have_content "Good morning!"
      expect(page).to have_content "kiyu@com"
    end
    it "fails to update" do
      fill_in "user[name]", with: ""
      click_button "Update"
      expect(page).to have_content "エラー"
    end
  end
end
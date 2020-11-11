require "rails_helper"

RSpec.describe "users page", type: :system do
  let(:user1){ create(:user1) }
  let!(:user2){ create(:user2) }
  before do 
    sign_in user1
  end
  
  context "on index page" do
    before do
      visit users_path
    end
    it "has 'Authors'" do
      expect(page).to have_content "Authors"
    end
    it "has table-heading" do
      expect(page).to have_content "Name"
      expect(page).to have_content "Word Count"
      expect(page).to have_content "Word tags"
    end
    it "has users table" do
      User.all.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_content user.words.count
        tags = user.words.map { |w| w.tag_list }.uniq.sample(4)
        tags.each do |tag|
          expect(page).to have_content tag
        end
      end
    end
    it "does not have button for myself" do
      expect(page).to have_no_link "Follow", href: follow_user_path(user1)
    end
    it "has button to follow" do
      expect(page).to have_link "Follow", href: follow_user_path(user2)
    end
    it "has button to unfollow user" do
      user1.follow(user2)
      visit current_path
      expect(page).to have_link "Unfollow", href: unfollow_user_path(user2)
    end
    it "has search_field" do
      expect(page).to have_field "q_name_start"
      expect(page).to have_button "Search"
    end
    it "can search by user_name" do
      fill_in "q_name_start", with: user1.name
      expect(page).to have_link user1.name, href: user_path(user1)
    end
  end
  
  context "on show page for own" do
    before do 
      visit user_path(user1)
    end
    it "has own image" do
      expect(page).to have_css ".my-img"
    end
    it "has own name" do
      expect(page).to have_content user1.name
    end
    it "has own introduction" do
      expect(page).to have_content user1.introduction
    end
    it "has link to followers" do
      expect(page).to have_link "Followers", href: followers_user_path(user1)
    end
    it "has number how many followers s/he has" do
      expect(page).to have_content user1.followers.count
    end
    it "has link to followings" do
      expect(page).to have_link "Followings", href: followings_user_path(user1)
    end
    it "has number how many followings s/he has" do
      expect(page).to have_content user1.followings.count
    end
    it "has own word count" do
      expect(page).to have_content user1.words.count
    end
    it "has link for editing own information" do
      expect(page).to have_link "Editing", href: edit_user_path(user1)
    end
    it "has count for how many words already posted" do
      expect(page).to have_content user1.words.count
    end
    it "has button if current_user == user you see" do
      expect(page).to have_link "New word", href: new_word_path
    end
    it "has words-img" do
      user1.words.each do |word|
        expect(page).to have_css "#word-img-#{ word.id }"
        expect(page).to have_link "More info", href: word_path(word)
      end
    end
  end
  
  context "on show page for others" do
    before do 
      visit user_path(user2)
    end
    it "does NOT have link for editing if it is not own information" do
      expect(page).to have_no_link "Editing", href: edit_user_path(user2)
    end
    it "has follow button if not following" do
      expect(page).to have_link "Follow", href: follow_user_path(user2)
    end
    it "has unfollow buttonn if following" do
      user1.follow(user2)
      visit current_path
      expect(page).to have_link "Unfollow", href: unfollow_user_path(user2)
    end
    it "does not have button if it is different user" do
      expect(page).to have_no_link "New wordr", href: new_word_path
    end
  end
  
  context "on edit page" do
    before do
      visit edit_user_path(user1)
    end
    it "fails to go to other's edit page" do
      visit edit_user_path(user2)
      expect(current_path).to eq user_path(user2)
    end
    it "has Your 'Profile'" do
      expect(page).to have_content "Your Profile"
    end
    it "has field for name" do
      expect(page).to have_content "Name"
      expect(page).to have_field "user[name]", with: user1.name
    end
    it "has field for introduction" do
      expect(page).to have_content "Introduction"
      expect(page).to have_field "user[introduction]", with: user1.introduction
    end
    it "has button to update" do
      expect(page).to have_button "Update"
    end
    it "succeeds to update" do
      attach_file "user[image]", "#{ Rails.root }/spec/factories/noimage.jpg"
      fill_in "user[name]", with: "Yuki Kis"
      fill_in "user[introduction]", with: "Nice to meet you"
      click_button "Update"
      expect(current_path).to eq user_path(user1)
      expect(page).to have_content "Yuki Kis"
      expect(page).to have_content "Nice to meet you"
    end
    it "fails to update" do
      fill_in "user[name]", with: ""
      click_button "Update"
      expect(page).to have_content "エラー"
    end
  end
end

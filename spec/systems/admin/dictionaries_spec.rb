require "rails_helper"

RSpec.describe "admin-dictionary", type: :system do
  let(:admin1){ create(:admin1) }
  let(:user1){ create(:user1) }
  let!(:word1){ create(:word1, user: user1) }
  let!(:word2){ create(:word2, user: user1) }

  before do
    user1.create_dictionary
    user1.dictionary.add(word1)
    user1.dictionary.add(word2)
    visit new_admin_session_path
    fill_in "admin[email]", with: admin1.email
    fill_in "admin[password]", with: admin1.password
    click_button "Log in"
  end
  context "on show page" do
    before do
      visit admin_user_dictionary_path(user1)
    end
    it "has name" do
      expect(page).to have_content user1.name
    end
    it "has word_count" do
      expect(page).to have_content user1.dictionary.words.count 
    end
    it "has dictionary_words" do
      words = user1.dictionary.words[0..20]
      words.each do |word|
        expect(page).to have_link "", href: admin_word_path(word1)
      end
    end
    it "has back_link" do
      expect(page).to have_link "ユーザー情報へ戻る", href: admin_user_path(user1)
    end
  end
end
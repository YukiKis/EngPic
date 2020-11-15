require "rails_helper"

RSpec.describe "admin top page", type: :system do
  let(:admin1){ create(:admin1) }
  let(:user1) { create(:user1) }
  let(:user2) { create(:user2) }
  let!(:word1) { create(:word1, user: user1) }
  let!(:word2) { create(:word2, user: user2) }
  context "on top page" do
    before do 
      user2.created_at = Date.yesterday
      word2.created_at = Date.yesterday
      sign_in admin1
      visit admin_top_path
    end
    it "has number of users who registered today" do
      user_count = User.today.count
      expect(page).to have_content user_count
    end
    it "has number of words whivh registered today" do
      word_count = Word.today.count
      expect(page).to have_content word_count
    end
    it "cannnot access if not log in as admin" do
      sign_out admin1
      sign_in user1
      visit admin_top_path
      expect(page).to have_content "ログインしてください"
    end
  end
end
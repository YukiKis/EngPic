require "rails_helper"

RSpec.describe "Homes", type: :system do
  let(:user1){ create(:user1) }
  let!(:word1){ create(:word1, user: user1) }
  let!(:word2){ create(:word2, user: user1) }
  context "on top page" do
    before do
      visit root_path
    end
    it "has link to tagged_words with tag name" do
      Word.tag_counts.sample(4).each do |t|
        expect(page).to have_link t.name, href: tagged_words_path(t.name)
      end
    end
    it "has link to word-index with word name" do
      words = Word.all.sample(4)
      words.each do |w|
        expect(page).to have_link w.name, href: same_name_words_path(w.name)
      end
    end
    it "has link to word-index with word meaning" do
      words = Word.all.sample(4)
      words.each do |w|
        expect(page).to have_link w.meaning, href: same_meaning_words_path(w.meaning)
      end
    end
  end
  context "on about page" do
    # it "has 'About'" do
    #   visit about_path
    #   expect(page).to have_content "ABOUT PAGE"
    # end
  end
  context "on howto page" do
    # it "has 'HOW TO PAGE" do
    #   visit howto_path
    #   expect(page).to have_content "HOW TO PAGE"
    # end
  end
end
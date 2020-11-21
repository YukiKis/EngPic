require "rails_helper"

RSpec.describe "admin-words page", type: :system do
  let(:admin1){ create(:admin1) }
  let(:user1){ create(:user1) }
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
      visit admin_words_path
    end
    it "has table for words" do
      Word.all[0..19].each do |word|
        expect(page).to have_css "#word-image-#{ word.id }"
        expect(page).to have_content word.name
        expect(page).to have_content word.user.name
        expect(page).to have_link word.user.name, href: admin_user_path(word.user)
      end
    end
    it "has search field for word" do
      expect(page).to have_field "q[name_or_meaning_start]"
    end
    it "can search by word_name" do
      fill_in "q[name_or_meaning_or_tags_name_start]", with: word1.name
      click_button "検索"
      words = Word.by_same_name(word1.name)[0..19]
      expect(current_path).to eq search_admin_words_path
      words.each do |word|
        expect(page).to have_link word.name, href: admin_word_path(word)
      end
    end
    it "can search by word_meaning" do
      fill_in "q[name_or_meaning_or_tags_name_start]", with: word1.meaning
      click_button "検索"
      words = Word.by_same_meaning(word1.meaning)[0..19]
      expect(current_path).to eq search_admin_words_path
      words.each do |word|
        expect(page).to have_link word.name, href: admin_word_path(word1)
      end
    end
    it "can search by tag" do
      fill_in "q[name_or_meaning_or_tags_name_start]", with: "doll"
      click_button "検索"
      words = Word.tagged_with("doll")[0..19]
      expect(current_path).to eq search_admin_words_path
      words.each do |word|
        expect(page).to have_link word.name, href: admin_word_path(word)
      end
    end
  end
  
  context "on show page" do
    before do 
      visit admin_word_path(word1)
    end
    it "has name" do
      expect(page).to have_content word1.name
    end
    it "has meaning" do
      expect(page).to have_content word1.meaning
    end
    it "has sentence" do
      expect(page).to have_content word1.sentence
    end
    it "has tag_list" do
      word1.tag_list.each do |t|
        expect(page).to have_content t
      end
    end
    it "has button to edit" do
      expect(page).to have_link "編集", href: edit_admin_word_path(word1)
    end
  end
  
  context "on edit page" do
    before do 
      visit edit_admin_word_path(word1)
    end
    it "has field for image" do
      expect(page).to have_field "word[image]"
    end
    it "has field for name" do
      expect(page).to have_field "word[name]", with: word1.name
    end
    it "has field for meaning" do
      expect(page).to have_field "word[meaning]", with: word1.meaning
    end
    it "hsa field for sentence" do
      expect(page).to have_field "word[sentence]", with: word1.sentence
    end
    it "has field for tag" do
      expect(page).to have_field "word[tag_list]", with: word1.tag_list
    end
    it "has button to update" do
      expect(page).to have_button "Update"
    end
    it "has button to back" do
      expect(page).to have_link "Back", href: admin_word_path(word1)
    end
    it "succeeds to update" do
      fill_in "word[name]", with: "model"
      fill_in "word[meaning]", with: "模型"
      fill_in "word[sentence]", with: "I love a model yesterday"
      fill_in "word[tag_list]", with: "model, bike, cool"
      attach_file "word[image]", "#{ Rails.root }/spec/factories/noimage.jpg"
      click_button "Update"
      word1.reload
      expect(current_path).to eq admin_word_path(word1)
      expect(page).to have_content "model"
      expect(page).to have_content "模型"
      expect(page).to have_content "I love a model yesterday"
      word1.tag_list.each do |t|
        expect(page).to have_content t
      end
    end
    it "fails to update" do
      fill_in "word[name]", with: ""
      click_button "Update"
      expect(page).to have_content "エラー"
    end
  end
end
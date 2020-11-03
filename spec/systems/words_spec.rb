require "rails_helper"

RSpec.describe "words page", type: :system do
  let(:user1){ create(:user1) }
  let(:user2){ create(:user2) }
  let(:word1){ create(:word1, user: user1) }
  let(:word2){ create(:word2, user: user2) }
  before do
    sign_in user1
  end
  context "on index page" do
    before do
      visit words_path
    end
    it "has word count" do
      exepct(page).to have_content Word.all.count
    end
    it "has word-cards" do
      Word.all.each do |word|
        expect(page).to have_css "#word-image-#{ word.id }"
        expect(page).to have_css "#user-image-#{ word.user.id }"
        expect(page).to have_content word.user.name
        expect(page).to have_link "", href: word_path(word)
      end
    end
  end
  
  context "on show page" do
    before do 
      visit word_path(word1)
    end
    it "has word-image" do
      expect(page).to have_css "#word-image-#{ word1.id }"
    end
    it "has tag-list" do
      word1.tag_list.each do |tag|
        expect(page).to have_content tag
        # expect(page).to have_link
      end
    end
    it "has button to add to dictionary" do
      # expect(page).to have_link "Add", href: 
    end
    it "has button to remove from dictionary" do
      # expect(page).to have_link "Remove" href: 
    end
    it "has button to edit word" do
      expect(page).to have_link "Edit", href: edit_word_path(word1)
    end
    it "does not have edit button if not right user" do
      visit word_path(word2)
      expect(page).to have_no_link "Edit", href: edit_word_path(word2)
    end
    it "has related words" do
      # expect(page).to have 
    end
  end
  context "on edit page" do
    before do
      visit edit_word_path(word1)
    end
    it "has image" do
      expect(page).to have_css ".image" 
    end
    it "has field for name" do
      expect(page).to have_content "Name"
      expect(page).to have_field "item[name]", with: word1.name
    end
    it "has field for meaning" do
      expect(page).to have_content "Meaning" 
      expect(page).to have_field "item[meaning]", with: word1.meaning
    end
    it "has field for sentence" do
      expect(page).to have_content "Sentence"
      expect(page).to have_field "item[sentence]", with: word1.sentence
    end
    it "has field for tag-list" do
      expect(page).to have_content "Tags"
      expect(page).to have_field "item[tag_list]", with: word1.tag_list
    end
    it "has radio_button for status" do
      expect(page).to have_content "Yes"
      expect(page).to have_field "item[status_true]"
      expect(page).to have_content "No"
      expect(page).to have_field "item[status_false]"
      expect(page).to have_checked_field word1.status
    end
    it "has button to update a word" do
      expect(page).to have_button "Update!"
    end
    it "succeeds to update a word" do
      attach_file "", "#{ Rails.root }/assets/images/noimage.jpg"
      fill_in "word[name]", with: "juice"
      fill_in "word[meaning]", with: "ジュース"
      fill_in "word[sentence]", with: "I like this juice" 
      fill_in "word[tag_list]", with: "drink, juice, tomato"
      choose "Yes"
      click_button "Update!"
      expect(current_path).to eq word_path(word1)
      expect(page).to have_content "juice"
      expect(page).to have_content "ジュース"
      expect(page).to have_content "I like this juice"
      word1.tag_list each do |tag|
        expecct(page).to have_conten tag
      end
    end
    it "fails to udpate" do
      fill_in "word[name]", with: ""
      click_button "Update!"
      expect(page).to have_content "エラー"
    end
  end
  context "on new page" do
    before do
      visit new_word_path(word1)
    end
    it "has image" do
      expect(page).to have_css ".image" 
    end
    it "has field for name" do
      expect(page).to have_content "Name"
      expect(page).to have_field "item[name]"
    end
    it "has field for meaning" do
      expect(page).to have_content "Meaning" 
      expect(page).to have_field "item[meaning]"
    end
    it "has field for sentence" do
      expect(page).to have_content "Sentence"
      expect(page).to have_field "item[sentence]"
    end
    it "has field for tag-list" do
      expect(page).to have_content "Tags"
      expect(page).to have_field "item[tag_list]"
    end
    it "has radio_button for status" do
      expect(page).to have_content "Yes"
      expect(page).to have_field "item[status_true]"
      expect(page).to have_content "No"
      expect(page).to have_field "item[status_false]"
    end
    it "has button to make a new word" do
      expect(page).to have_button "Create!"
    end
    it "succeeds to make a new word" do
      attach_file "", "#{ Rails.root }/assets/images/noimage.jpg"
      fill_in "word[name]", with: "medicine"
      fill_in "word[meaning]", with: "薬"
      fill_in "word[sentence]", with: "This medicine is very effective"
      fill_in "word[tag_list]", with: "medicine, hospital, doctor"
      choose "Yes"
      click_button "Create!"
      word = Word.last
      expect(current_path).to eq word_path(word)
      expect(page).to have_content "medicine"
      expect(page).to have_content "薬"
      expect(page).to have_content "This medicine is very effective"
      word.tag_list.each do |tag|
        expect(page).to have_content tag
      end
    end
    it "fails to make" do
      click_button "Create!"
      expect(page).to have_content "エラー"
    end
  end
end
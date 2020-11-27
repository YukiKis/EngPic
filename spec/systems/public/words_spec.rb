require "rails_helper"

RSpec.describe "words page", js: true, type: :system do
  let(:user1){ create(:user1) }
  let(:user2){ create(:user2) }
  let(:word1){ create(:word1, user: user1) }
  let(:word2){ create(:word2, user: user2) }
  let(:word3){ create(:word3, user: user1) }  # name: doll
  let(:word4){ create(:word4, user: user2) }  # name: doll
  let(:word5){ create(:word5, user: user1) }  # name: doll
  before do
    sign_in user1
    user1.create_dictionary
  end
  context "on index page" do
    before do
      visit words_path
    end
    it "has word count" do
      expect(page).to have_content Word.active.count
    end
    it "has link to go to new page" do
      expect(page).to have_link "New word", href: new_word_path
    end
    it "has word-cards" do
      Word.active.each do |word|
        expect(page).to have_css "#word-image-#{ word.id }"
        expect(page).to have_css "#user-image-#{ word.user.id }"
        expect(page).to have_content word.user.name
        expect(page).to have_link "", href: word_path(word)
      end
    end
    it "has blue color if it is NOT in dictionary but in words" do
      user1.dictionary.add(word1)
      user1.dictionary.remove(word1)
      visit current_path
      expect(page).to have_css "#card-1.bg-info"
    end
    it "has yellow color if in dictionary" do
      user1.dictionary.add(word1)
      visit current_path
      expect(page).to have_css "#card-1.bg-warning"
    end
    it "has search_form" do
      expect(page).to have_field "q_name_or_meaning_start"
      expect(page).to have_button "検索"
    end
    it "has reset button for all words" do
      expect(page).to have_link "All words", href: words_path
    end
    it "can search by word_name" do
      fill_in "q_name_or_meaning_start", with: word1.name
      click_button "検索"
      expect(current_path).to eq search_words_path
      expect(page).to have_link "", href: word_path(word1)
    end
    it "can search by word_meaning" do
      fill_in "q_name_or_meaning_start", with: word1.meaning
      click_button "検索"
      expect(current_path).to eq search_words_path
      expect(page).to have_link "", href: word_path(word1)
    end
    it "has example of tags" do
      tags = []
      Word.active.sample(4).each do |t|
        tags << t.name
      end
      tags.uniq.sample(4).each do |t|
        expect(page).to have_link t, href: tagged_words_path(t)
      end
    end
    it "has example of word names" do
      Word.active.sample(4).each do |w|
        expect(page).to have_link w.name, href: same_name_words_path(w.name)
      end
    end
    it "has example of word meanings" do
      Word.active.sample(4).each do |w|
        expect(page).to have_link w.meaning, href: same_meanings_words_path(w.meaning)
      end
    end
  end
  
  context "on same-name page" do
    before do
      visit same_name_words_path(word1.name)
    end
    it "has name of word" do
      expect(page).to have_content "'#{ word1.name }'"
    end
    it "has name which have same name with the word" do
      Word.active.by_same_name(word1.name).each do |w|
        expect(page).to have_link "", href: word_path(w)
      end
      expect(page).to have_content word3.name
    end
  end
  
  context "on same-meaning-page" do
    before do
      visit same_meaning_words_path(word1.meaning)
    end
    it "hsa meaning of the word" do
      expect(page).to have_content "'#{ word1.meaning }'"
    end
    it "has name which have same name with the word" do
      Word.active.by_same_meaning(word1.meaning).each do |w|
        expect(page).to have_link "", href: word_path(w)
      end
      expect(page).to have_content word3.meaning
    end

  end
  
  context "on show page" do
    before do 
      visit word_path(word1)
    end
    it "has link with name of user who made a word" do
      expect(page).to have_link "", href: user_path(word1.user)
      expect(page).to have_link word1.user.name, href: user_path(word1.user)
    end
    it "has word-image" do
      expect(page).to have_css "#word-image-#{ word1.id }"
    end
    it "has tag-list" do
      word1.tags.each do |tag|
        expect(page).to have_link tag.name, href: tagged_words_path(tag.name)
      end
    end
    it "has button to add to dictionary" do
      expect(page).to have_link "Add", href: add_dictionary_path(word1)
    end
    it "adds bg-warning when adding to dictionary" do
      user1.dictionary.remove(word1)
      user1.dictionary.add(word1)
      visit current_path
      expect(page).to have_css ".card-show.bg-warning"
    end
    it "has bg-info if NOT in dictioary but in words" do
      user1.dictionary.remove(word1)
      visit current_path
      expect(page).to have_css ".card-show.bg-info"
    end
    it "has button to remove from dictionary" do
      user1.dictionary.add(word1)
      visit current_path
      # ajaxのrspecのテスト、未解決のため一度更新して対応
      expect(page).to have_link "Remove", href: remove_dictionary_path(word1)
    end
    it "has button to edit word" do
      expect(page).to have_link "Edit", href: edit_word_path(word1)
    end
    it "does not have edit button if not right user" do
      visit word_path(word2)
      expect(page).to have_no_link "Edit", href: edit_word_path(word2)
    end
    it "has back link" do
      expect(page).to have_link "Back", href: words_path
    end
    it "has related words" do
      related_words = []
      word1.tag_list.each do |tag|
        Word.active.tagged_with(tag).sample(5).each do |w|
          if w == word1
          else
            related_words << w
          end
        end
      end
      @related_words = related_words.uniq.sample(4)
      @related_words.each do |w|
        expect(page).to have_link "", href: word_path(w)
      end
    end
  end
  
  context "on edit page" do
    before do
      visit edit_word_path(word1)
    end
    it "is edit_page if the word is current_user's" do
      expect(current_path).to eq edit_word_path(word1)
    end
    it "fails to visit edit page if the word is other's" do
      visit edit_word_path(word2)
      expect(current_path).to eq word_path(word2)
    end
    it "has image" do
      expect(page).to have_css ".image" 
    end
    it "has field for name" do
      expect(page).to have_content "Name"
      expect(page).to have_field "word[name]", with: word1.name
    end
    it "has field for meaning" do
      expect(page).to have_content "Meaning" 
      expect(page).to have_field "word[meaning]", with: word1.meaning
    end
    it "has field for sentence" do
      expect(page).to have_content "Sentence"
      expect(page).to have_field "word[sentence]", with: word1.sentence
    end
    it "has field for tag-list" do
      expect(page).to have_content "Tags"
      expect(page).to have_field "word[tag_list]", with: word1.tag_list
    end
    it "has button to update a word" do
      expect(page).to have_button "Update!"
    end
    it "has button to delete a word" do
      expect(page).to have_link "Delete", href: word_path(word1)
    end
    it "succeeds to update a word" do
      attach_file "word[image]", "#{ Rails.root }/spec/factories/noimage.jpg"
      fill_in "word[name]", with: "juice"
      fill_in "word[meaning]", with: "ジュース"
      fill_in "word[sentence]", with: "I like this juice" 
      fill_in "word[tag_list]", with: "drink, juice, tomato"
      click_button "Update!"
      word1.reload
      expect(current_path).to eq word_path(word1)
      expect(page).to have_content "juice"
      expect(page).to have_content "ジュース"
      expect(page).to have_content "I like this juice"
      word1.tag_list.each do |tag|
        expect(page).to have_content tag
      end
    end
    it "fails to udpate" do
      fill_in "word[name]", with: ""
      click_button "Update!"
      expect(page).to have_content "エラー"
    end
    it "succeeds to delete" do
      click_on "Delete"
      expect(current_path).to eq user_path(user1)
      expect(page).to have_no_content word1.name
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
      expect(page).to have_field "word[name]"
    end
    it "has field for meaning" do
      expect(page).to have_content "Meaning" 
      expect(page).to have_field "word[meaning]"
    end
    it "has field for sentence" do
      expect(page).to have_content "Sentence"
      expect(page).to have_field "word[sentence]"
    end
    it "has field for tag-list" do
      expect(page).to have_content "Tags"
      expect(page).to have_field "word[tag_list]"
    end
    it "has button to make a new word" do
      expect(page).to have_button "Create!"
    end
    it "succeeds to make a new word" do
      attach_file "word[image]", "#{ Rails.root }/spec/factories/noimage.jpg"
      fill_in "word[name]", with: "medicine"
      fill_in "word[meaning]", with: "薬"
      fill_in "word[sentence]", with: "This medicine is very effective"
      fill_in "word[tag_list]", with: "medicine, hospital, doctor"
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
  
  context "on tags_page" do
    before do 
      visit tags_words_path
    end
    it "has tag info" do
      Word.active.tag_counts.each do |t|
        expect(page).to have_link t.name, herf: tagged_words_path(t)
        expect(page).to have_content Word.active.tagged_with(t).count
        Word.active.tagged_with(t.name).sample(4).each do |w|
          expect(page).to have_link "", href: word_path(w)
        end
      end
    end
    it "has tag-search form" do
      expect(page).to have_field "q[name_start]"
      expect(page).to have_button "検索"
    end
    it "has reset button for tags_words_path" do
      expect(page).to have_link "All tags", href: tags_words_path
    end
    it "can search by tag" do
      tag = word1.tag_list.first
      fill_in "q[name_start]", with: tag
      click_button "検索"
      expect(page).to have_link tag, href: tagged_words_path(tag)
      Word.active.tagged_with(tag).sample(4).each do |w|
        expect(page).to have_link "", href: word_path(w)
      end
    end
  end
  
  context "on tags_search page" do
    before do
      visit tags_words_path
      fill_in "q_name_start", with: "doll"
      click_button "検索"
    end
    it "has tag name" do
      expect(page).to have_content "'doll'"
    end
    it "has tags index" do
      Word.active.tagged_with("doll").each do |w|
        expect(page).to have_link "", href: word_path(w)
      end
    end
  end
end
require "rails_helper"

RSpec.describe "dictionary page", type: :system do
  let(:user1){ create(:user1) }
  let(:word1){ create(:word1, user: user1) }
  let(:word2){ create(:word2, user: user1) }
  before do
    sign_in user1
    user1.create_dictionary
    user1.dictionary.add(word1)
    user1.dictionary.add(word2)
  end
  context "on show-pabe" do
    before do
      visit dictionary_path
    end
    it "has 'Your dictionary'" do
      expect(page).to have_content "Your Dictionary"
    end
    it "has number of words in dictionary" do
      expect(page).to have_content user1.dictionary.words.count
    end
    it "has link to words-index" do
      expect(page).to have_link "Check my dictionary", href: words_dictionary_path
    end
    it "has link to add a new word" do
      expect(page).to have_link "Add a new word", href: new_word_path
    end
    it "has date of last update" do
      expect(page).to have_content user1.dictionary.updated_at.strftime("%Y/%m/%d")
    end
    it "has link to choose how to test" do
      expect(page).to have_link "Let's test!", href: choose_dictionary_path
    end
  end
  context "dictionary words page" do
    before do 
      visit words_dictionary_path
    end
    it "has search_field" do
      expect(page).to have_field "q_name_or_meaning_or_tags_name_start"
      expect(page).to have_button "Search"
    end
    it "has word_count in dictionary" do
      expect(page).to have_content user1.dictionary.words.count
    end
    
    # same as words-index
  end
  context "on choose page" do
    before do
      visit choose_dictionary_path
    end
    it "has 'Check your vocabulary'" do
      expect(page).to have_content "Check your vocabulary"
    end
    it "has field to choose from tags" do
      w1tags = word1.tags.map { |t| t.name }
      w2tags = word2.tags.map { |t| t.name }
      tags = w1tags.concat(w2tags).uniq
      expect(page).to have_select("category[tag]", options: tags)
      expect(page).to have_button "Check!"
    end
    it "has link to start with all words" do
      expect(page).to have_link "Check!", href: question_dictionary_path
    end
    it "has link to back to dictionary-show" do
      expect(page).to have_link "Back", href: dictionary_path
    end
  end
  context "on dictionary-question-page" do
    before do
      visit choose_dictionary_path
      click_link "Check!", href: question_dictionary_path
      @questions = user1.dictionary.words.all[0..1]
    end
    it "has number of questions" do
      expect(page).to have_content @questions.count
    end
    it "has forms for question" do
      @questions.each do |q|
        expect(page).to have_css "#img-#{ q.id }"
        expect(page).to have_css "#label-#{ q.id }"
        expect(page).to have_field "check[answer#{ q.id }]"
      end
    end
    it "has button to submit" do
      expect(page).to have_button "Finish!"
    end
  end
  context "on dictionary-result-page" do
    before do
      visit choose_dictionary_path
      click_link "Check!", href: question_dictionary_path
      @questions = user1.dictionary.words.all[0..1]
      @rights = 0
      @answers = []
      @questions.each do |q|
        fill_in "check[answer#{ q.id }]", with: q.name
        # ALL CORRECT
        @rights += 1
        @answers << q.name
      end
      click_button "Finish!"
    end
    it "has count of questions" do
      expect(page).to have_content @questions.count
    end
    it "has count of the right-answer" do
      expect(page).to have_content @rights
    end
    it "has info for each questions" do
      @questions.each_with_index do |question, i|
        expect(page).to have_css "#img-#{ question.id }"
        expect(page).to have_content @answers[ i ]
        expect(page).to have_content question.name
      end
    end
    it "has yellow color if answer is wrong" do
      @questions.each do |question|
        expect(page).to have_css "#card-#{ question.id }.bg-warning"
      end
    end
    it "has blue color if answer is right" do
      @questions.each do |question|
        expect(page).to have_css "#card-#{ question.id }.bg-info"
      end
    end
  end
end
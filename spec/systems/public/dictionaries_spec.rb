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
  context "on show-page" do
    before do
      visit dictionary_path
    end
    it "has 'Your dictionary'" do
      expect(page).to have_content "Your Dictionary"
    end
    it "has number of words in dictionary" do
      expect(page).to have_content user1.dictionary.words.count
    end
    it "has tags-index" do
      user1.dictionary.words.joins(:user).where(users: { is_active: true }).tag_counts.each do |t|
        expect(page).to have_link t.name, href: tagged_words_dictionary_path(t.name)
        expect(page).to have_content user1.dictionary.words.tagged_with(t).count
      end
    end
    it "has reset button for tagging" do
      expect(page).to have_link "All words", href: dictionary_path
    end
    it "has all-tags-in dictionary button" do
      expect(page).to have_link "All tags", href: tags_dictionary_path
    end
    it "has words-index" do
      words = [word1, word1]
      visit current_path
      words.each do |w|
        expect(page).to have_link "", href: word_path(w)
        expect(page).to have_content w.name
      end
    end
    it "has link to add a new word" do
      expect(page).to have_link "New word", href: new_word_path
    end
    it "has date of last update" do
      expect(page).to have_content user1.dictionary.updated_at.strftime("%Y/%m/%d")
    end
    it "has link to choose how to test" do
      expect(page).to have_link "Test!", href: choose_dictionary_path
    end
  end
  
  context "on tags page" do
    before do 
      visit tags_dictionary_path
    end
    it "has tag_list" do
      user1.dictionary.words.joins(:user).where(users: { is_active: true }).tag_counts.each do |t|
        expect(page).to have_link t.name, href: tagged_words_dictionary_path(t.name)
        expect(page).to have_content user1.dictionary.words.tagged_with(t.name).count
        # expect(page).to have_link "", href: word_path has images, randomly selected, which have link for word_path
      end
    end
  end
  
  context "on tagged_words_dictionary page" do
    before do
      @tag = user1.dictionary.words.joins(:user).where(users: { is_active: true }).tag_counts.first
      visit tagged_words_dictionary_path(@tag.name)
    end
    it "has tag_name heading" do
      expect(page).to have_content "'#{@tag.name}'"
    end
    it "has word counts tagged with the tag" do
      expect(page).to have_content "#{ user1.dictionary.words.tagged_with(@tag).count}"
    end
  end
    
  
  context "on tagged page" do
    before do
      @tag = word1.tag_list.first
      visit dictionary_path
      click_link @tag, href: tagged_dictionary_path(@tag)
    end
    it "has 'Your dictionary'" do
      expect(page).to have_content "Your Dictionary"
    end
    it "has number of words in dictionary" do
      expect(page).to have_content user1.dictionary.words.joins(:user).where(users: { is_active: true } ).count
    end
    it "has tags-index" do
      user1.dictionary.words.joins(:user).where(users: { is_active: true }).tag_counts.each do |t|
        expect(page).to have_link t.name, href: tagged_dictionary_path(t.name)
        expect(page).to have_content t.taggings_count
      end
    end
    it "has words-index" do
      words = [word1, word1]
      visit current_path
      words.each do |w|
        expect(page).to have_link "", href: word_path(w)
        expect(page).to have_content w.name
      end
    end
    it "has link to add a new word" do
      expect(page).to have_link "New word", href: new_word_path
    end
    it "has date of last update" do
      expect(page).to have_content user1.dictionary.updated_at.strftime("%Y/%m/%d")
    end
    it "has link to choose how to test" do
      expect(page).to have_link "Test!", href: choose_dictionary_path
    end    
    it "has words with the same tag" do
      words = user1.dictionary.words.joins(:user).where(users: { is_active: true }).tagged_with(@tag)
      words.each do |word|
        expect(page).to have_link "", href: word_path(word)
      end
    end
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
      @questions = user1.dictionary.words.joins(:user).where(users: { is_active: true })
    end
    it "has number of questions" do
      expect(page).to have_content @questions.count
    end
    it "has forms for question" do
      @questions.each_with_index do |q, i|
        expect(page).to have_css "#img-#{ i }"
        expect(page).to have_css "#label-#{ i }"
        expect(page).to have_field "check[answer#{ i }]"
      end
    end
    it "has button to submit" do
      expect(page).to have_button "Finish!"
    end
    it "selects from tag" do
      visit choose_dictionary_path
      select "toy", from: "category[tag]"
      click_button "Check!"
      questions = user1.dictionary.words.joins(:user).where(users: { is_active: true }).tagged_with("toy")
      questions.each_with_index do |q, i|
        expect(page).to have_css "#img-#{ i }"
        expect(page).to have_css "#label-#{ i }"
        expect(page).to have_field "check[answer#{ i }]"
      end
    end
  end
  
  context "on dictionary-result-page" do
    before do
      visit choose_dictionary_path
      click_link "Check!", href: question_dictionary_path
      @questions = user1.dictionary.words.joins(:user).where(users: { is_active: true })
      @rights = 0
      @answers = []
      @questions.each_with_index do |q, i|
        # ALL CORRECT
        fill_in "check[answer#{ i }]", with: q.name
        @rights += 1
        @answers << q.name
      end
      click_on "Finish!"
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
    it "has blue color if answer is right" do
      @questions.each do |q|
        expect(page).to have_css "#card-#{ q.id }.bg-info"
      end
    end
    it "has red color if answer is wrong" do
      visit choose_dictionary_path
      click_link "Check!", href: question_dictionary_path
      questions = user1.dictionary.words.all
      click_button "Finish!"
      expect(current_path).to eq check_dictionary_path
      questions.each do |q|
        expect(page).to have_css "#card-#{ q.id }.bg-danger"
      end
    end
  end
end
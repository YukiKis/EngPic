require "rails_helper"

RSpec.describe "test-through", type: :system, js: true do
  let(:admin1){ create(:admin1) }
  # @user1: { name: yuki, email: yuki@com }
  context "Test through" do
    it "tests through all steps" do
      # visit new_user_registration page
      visit root_path
      click_link "Register", href: new_user_registration_path
      expect(current_path).to eq new_user_registration_path

      # make new user
      fill_in "user[name]", with: "yuki"
      fill_in "user[introduction]", with: "Hello!"
      fill_in "user[email]", with: "yuki@com"
      fill_in "user[password]", with: "testtest"
      fill_in "user[password_confirmation]", with: "testtest"
      click_button "登録"
      @user1 = User.first # passwordが入っていないため以降"testtest"を直打ち
      expect(current_path).to eq user_path(@user1)
      expect(page).to have_content @user1.name
      
      # visit new_word_path
      click_link "New word", href: new_word_path
      expect(current_path).to eq new_word_path
      
      # make new word
      attach_file "word[image]", "#{ Rails.root }/spec/factories/noimage.jpg"
      fill_in "word[name]", with: "sample"
      fill_in "word[meaning]", with: "サンプル"
      fill_in "word[sentence]", with: "This is a sample"
      fill_in "word[tag_list]", with: "sample, example"
      click_button "Create!"
      @word1 = Word.first
      expect(current_path).to eq word_path(@word1)
      expect(page).to have_content "sample"
      expect(page).to have_content @word1.name # @word1.name = sampleか確認
      
      # fails to make new word
      click_link "MyPage", href: user_path(@user1)
      click_link "New word", href: new_word_path
      click_button "Create!"
      expect(page).to have_content "エラー"
      
      # visit dictionary_path
      click_link "Dictionary", href: dictionary_path
      expect(current_path).to eq dictionary_path
      
      # check the registererd word is in dictionary
      expect(page).to have_content @user1.dictionary.words.count # total of dictioanry words
      expect(page).to have_content @user1.dictionary.words.tag_counts.count #total of dictionary tags
      expect(page).to have_link "", href: word_path(@word1)
      
      # check it has tag-index 
      @user1.dictionary.words.active.tag_counts.each do |t|
        expect(page).to have_link t.name, href: tagged_words_dictionary_path(t.name)
        expect(page).to have_content t.taggings_count
      end
      
      # check dictionary word
      click_link "Test!", href: choose_dictionary_path
      expect(current_path).to eq choose_dictionary_path
      
      # choose from a tag and visit question_dictionary_page
      select "sample", from: "category[tag]"
      click_button "Check!"
      expect(current_path).to eq question_dictionary_path
      
      # answer correctly
      fill_in "check[answer0]", with: "sample" #only one word in dictionary now
      click_on "Finish!"
      expect(current_path).to eq check_dictionary_path
      
      # have blue color and get correct score
      expect(page).to have_content "You made 1 / 1!"
      expect(page).to have_css "#card-1.bg-info"
      
      # test again by all words in dictionary
      click_link "Test Again!", href: choose_dictionary_path
      expect(current_path).to eq choose_dictionary_path
      click_link "Check!", href: question_dictionary_path
      expect(current_path).to eq question_dictionary_path
      
      # answer wrong
      fill_in "check[answer0]", with: "aaa" #only one word in dictionary still
      click_on "Finish!"
      expect(current_path).to eq check_dictionary_path
      
      # have red color and get corrent score
      expect(page).to have_content "You made 0 / 1!"
      expect(page).to have_css "#card-1.bg-danger"
      
      # check whether redirect to choose path if it is on question_path
      click_link "Test Again!"
      click_link "Check!", href: question_dictionary_path
      click_on "Finish!"
      expect(current_path).to eq check_dictionary_path
      visit current_path
      expect(current_path).to eq choose_dictionary_path
      expect(page).to have_content "エラーが発生"
      
      # check word has yellow color if it is in the dictionary
      click_link "MyPage", href: user_path(@user1)
      expect(current_path).to eq user_path(@user1)
      expect(page).to have_css "#card-1.bg-warning"
      
      # visit word_path
      click_link "", href: word_path(@word1)
      expect(current_path).to eq word_path(@word1)
      
      # visit edit_word_path
      click_link "Edit", href: edit_word_path(@word1)
      expect(current_path).to eq edit_word_path(@word1)
      
      # update word
      attach_file "word[image]", "#{ Rails.root }/spec/factories/noimage.jpg"
      fill_in "word[name]", with: "example"
      fill_in "word[meaning]", with: "例"
      fill_in "word[sentence]", with: "I love this example"
      fill_in "word[tag_list]", with: "example, eg, sample"
      click_button "Update!"
      @word1.reload
      expect(current_path).to eq word_path(@word1)
      expect(page).to have_content "example"
      expect(page).to have_content @word1.name
      
      # change into admin
      click_link "Sign out", href: destroy_user_session_path
      visit new_admin_session_path
      expect(current_path).to eq new_admin_session_path
      
      # login as admin
      fill_in "admin[email]", with: admin1.email
      fill_in "admin[password]", with: admin1.password
      click_button "Log in"
      expect(current_path).to eq admin_top_path
      
      # show word and user count which are registererd today
      expect(page).to have_link "", href: today_admin_users_path
      expect(page).to have_link "", href: today_admin_words_path
      
      # check today_admin_users page
      click_link "", href: today_admin_users_path
      expect(current_path).to eq today_admin_users_path
      expect(page).to have_link @user1.name, href: admin_user_path(@user1)
      
      # back to admin_top paga
      click_link "Home", href: admin_top_path
      expect(current_path).to eq admin_top_path
      
      # check today_admin_words page
      click_link "", href: today_admin_words_path
      expect(current_path).to eq today_admin_words_path
      expect(page).to have_link @word1.name, href: admin_word_path(@word1)
      
      # back to admin_top page
      click_link "EngPic", href: admin_top_path
      expect(current_path).to eq admin_top_path
      
      # visit admin_users_path
      click_link "Users", href: admin_users_path
      expect(current_path).to eq admin_users_path
      expect(page).to have_link @user1.name, href: admin_user_path(@user1)
      
      # visit admin_user_path
      click_link @user1.name, href: admin_user_path(@user1)
      expect(current_path).to eq admin_user_path(@user1)
      expect(page).to have_content @user1.name
      
      # visit edit_admin_user_path
      click_link "編集", href: edit_admin_user_path(@user1)
      expect(current_path).to eq edit_admin_user_path(@user1)
      expect(page).to have_content "編集"
      
      # update user info by admin
      fill_in "user[name]", with: "yuka"
      fill_in "user[introduction]", with: "Hello!"
      fill_in "user[email]", with: "yuka@com"
      click_button "Update"
      @user1.reload
      expect(current_path).to eq admin_user_path(@user1)
      expect(page).to have_content "yuka"
      expect(page).to have_content "yuka@com"
      expect(page).to have_content "Hello!"
      
      # fail to update
      click_link "編集", href: edit_admin_user_path(@user1)
      expect(current_path).to eq edit_admin_user_path(@user1)
      fill_in "user[name]", with: ""
      click_button "Update"
      expect(page).to have_content "エラー"
      
      # back to admin_user page
      click_link "Back", href: admin_user_path(@user1)
      expect(current_path).to eq admin_user_path(@user1)

      # has word-list
      expect(page).to have_link "", href: admin_word_path(@word1)
      
      # visit admin_word page
      click_link "", href: admin_word_path(@word1)
      expect(current_path).to eq admin_word_path(@word1)
      expect(page).to have_content @word1.name
      
      # visit edit_admin_word page 
      click_link "編集", href: edit_admin_word_path(@word1)
      expect(current_path).to eq edit_admin_word_path(@word1)
      expect(page).to have_field "word[name]", with: @word1.name
      
      # update word by admin
      fill_in "word[name]", with: "SAMPLE"
      fill_in "word[sentence]", with: "I love this SAMPLE"
      click_button "Update"
      @word1.reload
      expect(current_path).to eq admin_word_path(@word1)
      expect(page).to have_content "SAMPLE"
      expect(page).to have_content "I love this SAMPLE"
      expect(page).to have_content @word1.name # @word1.name = "SAMPLE"
      expect(page).to have_content @word1.sentence # @word1.sentence = "I love this SAMPLE"
      
      # fails to update
      click_link "編集", href: edit_admin_word_path(@word1)
      fill_in "word[name]", with: ""
      click_button "Update"
      expect(page).to have_content "エラー"
      
      # visit admin_user_dictionary page
      click_link "Back", href: admin_word_path(@word1)
      expect(current_path).to eq admin_word_path(@word1)
      click_link "Users", href: admin_users_path
      expect(current_path).to eq admin_users_path
      click_link @user1.name, href: admin_user_path(@user1)
      expect(current_path).to eq admin_user_path(@user1)
      click_link "辞書", href: admin_user_dictionary_path(@user1)
      expect(current_path).to eq admin_user_dictionary_path(@user1)
      expect(page).to have_content "#{ @user1.name }の辞書"
      
      # check it has @word1
      expect(page).to have_link "", href: admin_word_path(@word1)
      
      # logout and login ad @user1
      click_link "Sign out", href: destroy_admin_session_path
      click_link "Log in", href: new_user_session_path
      fill_in "user[email]", with: @user1.email
      fill_in "user[password]", with: "testtest"
      click_button "Log in"
      expect(current_path).to eq user_path(@user1)
      
      # check the word name has been changed
      expect(page).to have_content "SAMPLE"
  
      # check that it has button to remove word from dictionary
      click_link "", href: word_path(@word1)
      expect(current_path).to eq word_path(@word1)
      expect(page).to have_link "Remove", href: remove_dictionary_path(@word1)
      
      # remove word from dictionary
      click_link "Remove", href: remove_dictionary_path(@word1)
      @user1.dictionary.reload
      visit word_path(@word1)
      expect(page).to have_link "Add", href: add_dictionary_path(@word1)
      
      # check on mypage it is in blue
      click_link "MyPage", href: user_path(@user1)
      expect(current_path).to eq user_path(@user1)
      expect(page).to have_css "#card-1.bg-info"
      
      # no words in dictionary page
      click_link "Dictionary", href: dictionary_path
      expect(current_path).to eq dictionary_path
      expect(page).to have_no_link "", href: word_path(@word1)
      expect(page).to have_content "0 words and 0 tags"
      
      # make new word
      click_link "New word", href: new_word_path
      attach_file "word[image]", "#{ Rails.root }/spec/factories/noimage.jpg"
      fill_in "word[name]", with: "example"
      fill_in "word[meaning]", with: "例"
      fill_in "word[sentence]", with: "This is new example"
      fill_in "word[tag_list]", with: "example, sample"
      click_button "Create!"
      @word2 = Word.second
      expect(current_path).to eq word_path(@word2)
      expect(page).to have_content "example"
      
      # has the word in dictionary
      click_link "Dictionary", href: dictionary_path
      expect(current_path).to eq dictionary_path
      expect(page).to have_link "", href: word_path(@word2)
      
      # search, but no word in dictionary
      fill_in "q[name_or_meaning_start]", with: "SAMPLE"
      click_button "検索"
      expect(current_path).to eq search_dictionary_path
      expect(page).to have_no_link "", href: word_path(@word1)
      expect(page).to have_no_content "SAMPLE"
      
      # search, and find word in dictionary
      fill_in "q[name_or_meaning_start]", with: "example"
      click_button "検索"
      expect(current_path).to eq search_dictionary_path
      expect(page).to have_link "", href: word_path(@word2)
      expect(page).to have_content "1 word"
      expect(page).to have_content "2 tags"
      
      # check no category of @word1 in select box of choose page
      click_link "Test!"
      expect(current_path).to eq choose_dictionary_path
      expect(page).to have_no_select "eg"
    
      # check the new category shows up
      expect(page).to have_select "category[tag]", options: ["sample", "example"]
      
      # click tag-index
      click_link "Dictionary", href: dictionary_path
      click_link "All tags", href: tags_dictionary_path
      tag = @user1.dictionary.words.active.first.tag_list.first
      click_link tag, href: tagged_words_dictionary_path(tag)
      expect(current_path).to eq tagged_words_dictionary_path(tag)
      expect(page).to have_content tag
      @user1.dictionary.words.active.tagged_with(tag).each do |w|
        expect(page).to have_link "", href: word_path(w)
      end
      
      # search with tag
      click_link "Dictionary", href: dictionary_path
      click_link "All tags", href: tags_dictionary_path
      fill_in "q_name_start", with: "sample"
      click_button "検索"
      expect(current_path).to eq tag_search_dictionary_path
      expect(page).to have_link "sample", href: tagged_words_dictionary_path("sample")
      expect(page).to have_link "", href: word_path(@word2)
      @user1.dictionary.words.active.tagged_with("example").each do |w|
        expect(page).to have_link "", href: word_path(w)
      end
      
      # logout adn login as admin
      click_link "Sign out", href: destroy_user_session_path
      visit new_admin_session_path
      fill_in "admin[email]", with: admin1.email
      fill_in "admin[password]", with: admin1.password
      click_button "Log in"
      expect(current_path).to eq admin_top_path
      
      # visit user's dictionary page
      click_link "Users", href: admin_users_path
      expect(current_path).to eq admin_users_path
      click_link @user1.name, href: admin_user_path(@user1)
      expect(current_path).to eq admin_user_path(@user1)
      click_link "辞書", href: admin_user_dictionary_path(@user1)
      expect(current_path).to eq admin_user_dictionary_path(@user1)
      expect(page).to have_content "#{ @user1.name }の辞書"
      
      #check that no @word1, but @word2
      expect(page).to have_no_link "", href: admin_word_path(@word1)
      expect(page).to have_link "", href: admin_word_path(@word2)
      
      # make another new user
      click_link "Sign out", href: destroy_admin_session_path
      click_link "Register", href: new_user_registration_path
      expect(current_path).to eq new_user_registration_path
      fill_in "user[name]", with: "yuta"
      fill_in "user[introduction]", with: "Hello!"
      fill_in "user[email]", with: "yuta@com"
      fill_in "user[password]", with: "testtest"
      fill_in "user[password_confirmation]", with: "testtest"
      click_button "登録"
      @user2 = User.second
      expect(current_path).to eq user_path(@user2)
      expect(page).to have_content @user2.name
      expect(page).to have_link "Edit", href: edit_user_path(@user2)
      expect(page).to have_no_link "Follow", href: follow_user_path(@user2)
      
      # check another user does not have edit button but follow button
      click_link "Users", href: users_path
      expect(current_path).to eq users_path
      click_link @user1.name, href: user_path(@user1)
      expect(current_path).to eq user_path(@user1)
      expect(page).to have_no_link "Edit", href: edit_user_path(@user1)
      expect(page).to have_link "Follow", href: follow_user_path(@user1)
      
      # follow another user
      click_link "Follow", href: follow_user_path(@user1)
      visit user_path(@user1)
      expect(page).to have_link "Unfollow", href: unfollow_user_path(@user1) 
      
      # check that another user get follower
      expect(page).to have_content @user1.followers.active.count
      click_link "Followers", href: followers_user_path(@user1)
      expect(current_path).to eq followers_user_path(@user1)
      expect(page).to have_link @user2.name, href: user_path(@user2)
      
      #check that the user get following
      click_link "MyPage", href: user_path(@user2)
      expect(current_path).to eq user_path(@user2)
      expect(page).to have_content @user2.followings.active.count
      click_link "Followings", href: followings_user_path(@user2)
      expect(current_path).to eq followings_user_path(@user2)
      expect(page).to have_link @user1.name, href: user_path(@user1)
      
      # can search user
      click_link "Users", href: users_path
      expect(current_path).to eq users_path
      expect(page).to have_field "q[name_start]"
      fill_in "q[name_start]", with: @user1.name
      click_button "検索"
      expect(current_path).to eq search_users_path
      expect(page).to have_link @user1.name, href: user_path(@user1)
      
      #logout and login as the old user
      click_link "Sign out", href: destroy_user_session_path
      click_link "Log in", href: new_user_session_path
      expect(current_path).to eq new_user_session_path
      fill_in "user[email]", with: @user1.email
      fill_in "user[password]", with: "testtest"
      click_button "Log in"
      expect(current_path).to eq user_path(@user1)
      
      # delete word
      click_link "", href: word_path(@word1)
      expect(current_path).to eq word_path(@word1)
      click_link "Edit", href: edit_word_path(@word1)
      expect(current_path).to eq edit_word_path(@word1)
      click_link "Delete", href: word_path(@word1)
      expect(current_path).to eq user_path(@user1)
      expect(current_path).to have_no_link "", href: word_path(@word1)
      
      # logout and login as admin
      click_link "Sign out", href: destroy_user_session_path
      visit new_admin_session_path
      expect(current_path).to eq new_admin_session_path
      fill_in "admin[email]", with: admin1.email
      fill_in "admin[password]", with: admin1.password
      click_button "Log in"
      expect(current_path).to eq admin_top_path
      
      # check the word is deleted
      click_link "Words", href: admin_words_path
      expect(current_path).to eq admin_words_path
      expect(page).to have_no_link "", href: admin_word_path(@word1)
      
      # Sign out
      click_link "Sign out", href: destroy_admin_session_path

      # visit new_user_password_path
      click_link "Log in", href: new_user_session_path
      click_link "or Forget Password?", href: new_user_password_path
      expect(current_path).to eq new_user_password_path
      
      # get password_reset email
      fill_in "user[email]", with: @user1.email
      expect{ click_button "送信" }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      email = ActionMailer::Base.deliveries.last
      # @path = "/users/password/edit?reset_password_token=.*/"
      expect(email.body).to have_content @user1.email
      # expect(email.body.raw_source).to match(/#{ @path }/)
      
      # Login
      click_link "Log in", href: new_user_session_path
      fill_in "user[email]", with: @user1.email
      fill_in "user[password]", with: "testtest"
      click_button "Log in"
      expect(current_path).to eq user_path(@user1)
      
      # Quit
      click_link "Edit", href: edit_user_path(@user1)
      expect(current_path).to eq edit_user_path(@user1)
      click_link "退会する", href: leave_user_path(@user1)
      expect(current_path).to eq leave_user_path(@user1)
      expect{ click_link "はい", href: quit_user_path(@user1) }.to change{ User.active.count }.by(-1)
      expect(current_path).to eq root_path
      expect(page).to have_content "退会しました。"
      
      # check not be able to login with quit user email
      click_link "Log in", href: new_user_session_path
      fill_in "user[email]", with: @user1.email
      fill_in "user[password]", with: "testtest"
      click_button "Log in"
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content "退会済み"
      
      # sign up for new user using same email
      click_link "Register", href: new_user_registration_path
      fill_in "user[name]", with: @user1.name
      fill_in "user[email]", with: @user1.email
      fill_in "user[password]", with: "testtest"
      fill_in "user[password_confirmation]", with: "testtest"
      click_button "登録"
      @user3 = User.last
      expect(current_path).to eq user_path(@user3)
      
      # change into admin
      click_link "Sign out", href: destroy_user_session_path
      visit new_admin_session_path
      fill_in "admin[email]", with: admin1.email
      fill_in "admin[password]", with: admin1.password
      click_button "Log in"
      expect(current_path).to eq admin_top_path

      # check the quit user
      click_link "Users", href: admin_users_path
      expect(page).to have_css "#user-info-1.inactive"
      click_link "", href: admin_user_path(@user1)
      expect(current_path).to eq admin_user_path(@user1)
      expect(page).to have_content "退会"
      expect(page).to have_content "quit" + Time.now.to_s.gsub(" ", "") + @user1.email
    end
  end
end
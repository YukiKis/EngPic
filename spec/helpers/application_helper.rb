require "rails_helper"

RSpec.describe "ApplicationHelper", type: :helper do
  include ApplicationHelper
  context "with title helper" do
    it "has base title" do
      expect(full_title).to eq "EngPic"
    end
    it "has base title and page title" do
    	page_title = "example"
    	expect(full_title(page_title)).to eq "EngPic | example"
    end
  end
  
  context "with counter" do
  	let!(:user1){ create(:user1) }
  	let!(:word1){ create(:word1, user: user1) }
  	let!(:word2){ create(:word2, user: user1) }
  	it "has singular word" do
  		expect(counter(User.all.count, "user")).to eq "1 user"
  	end
  	it "has plural words" do
  		expect(counter(Word.all.count, "word")).to eq "2 words"
  	end
  end
end
require "rails_helper"

RSpec.describe "word", type: :model do
  let(:user1){ create(:user1) }
  let(:user2){ create(:user2) }
  let(:word1){ build(:word1, user: user1) }
  let(:word2){ create(:word2, user: user1) } #book
  let(:word3){ create(:word3, user: user1) } #doll
  context "on validation" do
    it "has_many items" do
      expect(Word.reflect_on_association(:items).macro).to eq :has_many
    end
    it "has_many dictionaries through items" do
      expect(Word.reflect_on_association(:dictionaries).macro).to eq :has_many
    end
    it "belongs_to user" do
      expect(Word.reflect_on_association(:user).macro).to eq :belongs_to
    end
    it "is valid" do
      expect(word1).to be_valid
    end
    it "is invalid without name" do
      word1.name = ""
      expect(word1).to be_invalid
    end
    it "is invalid without meaning" do
      word1.meaning = ""
      expect(word1).to be_invalid
    end
    it "is invalid without image" do
      word1.image = ""
      expect(word1).to be_invalid
    end
    it "can scope by same name" do
      expect(Word.by_same_name(word2.name)).to eq [word2]
    end
    it "can scope by same meaning" do
      expect(Word.by_same_meaning(word2.meaning)).to eq [word2]
    end
    it "can scope by words that registered today" do
      word3.created_at = Date.yesterday
      word3.save
      expect(Word.today).to eq [word2]
    end
    it "can scope by words whose users are active" do
      word3.user_id = user2.id
      word3.save
      user2.is_active = false
      user2.save
      expect(Word.active).to eq [word2]
    end
    it "has tags" do
      expect(Word.reflect_on_association(:tags).macro).to eq :has_many
    end
  end
end
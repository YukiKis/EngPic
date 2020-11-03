require "rails_helper"

RSpec.describe "word", type: :model do
  let(:user1){ create(:user1) }
  let(:word1){ build(:word1, user: user1) }
  context "on validation" do
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
      word1.image_id = ""
      expect(word1).to be_invalid
    end
  end
end
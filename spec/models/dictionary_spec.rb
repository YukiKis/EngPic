require 'rails_helper'

RSpec.describe Dictionary, type: :model do
  let(:user1){ create(:user1) }
  let(:word1){ create(:word1, user: user1) }
  before do
    user1.create_dictionary
  end
  context "on validation" do
    it "has_many items" do
      expect(Dictionary.reflect_on_association(:items).macro).to eq :has_many
    end
    it "has_many words through items" do
      expect(Dictionary.reflect_on_association(:words).macro).to eq :has_many
    end
    it "belongs_to user" do
      expect(Dictionary.reflect_on_association(:user).macro).to eq :belongs_to      
    end
    it "can add a word" do
      expect{ user1.dictionary.add(word1) }.to change{ user1.dictionary.words.count }.from(0).to(1)
    end
    it "can remove a word" do
      user1.dictionary.add(word1)
      expect{ user1.dictionary.remove(word1) }.to change{ user1.dictionary.words.count }.from(1).to(0)
    end
  end
end

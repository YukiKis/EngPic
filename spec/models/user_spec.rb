require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { build(:user1) }
  context "on user validation" do
    it "has_many words" do
      expect(User.reflect_on_association(:words).macro).to eq :has_many
    end
    it "is valid" do
      expect(user1).to be_valid
    end
    it "is invalid without name" do
      user1.name = ""
      expect(user1).to be_invalid
    end
    it "is invalid if name is too short" do
      user1.name = "a"
      expect(user1).to be_invalid
    end
    it "is invalid if name is too long" do
      user1.name = "a"* 100
      expect(user1).to be_invalid
    end
  end
end

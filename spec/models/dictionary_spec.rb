require 'rails_helper'

RSpec.describe Dictionary, type: :model do
  context "on validation" do
    it "has_many items" do
      expect(Dictionary.reflect_on_association(:items).macro).to eq :has_many
    end
    it "belongs_to user" do
      expect(Dictionary.reflect_on_association(:user).macro).to eq :belongs_to      
    end
  end
  
end

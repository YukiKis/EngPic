require 'rails_helper'

RSpec.describe Item, type: :model do
  context "on validation" do
    it "belongs_to word" do
      expect(Item.reflect_on_association(:word).macro).to eq :belongs_to
    end
    it "belongs_to dictionary" do
      expect(Item.reflect_on_association(:dictionary).macro).to eq :belongs_to
    end
  end
end

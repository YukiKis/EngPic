require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:admin1){ build(:admin1) }
  context "on validation" do
    it "is valid" do
      expect(admin1).to be_valid
    end
  end
end

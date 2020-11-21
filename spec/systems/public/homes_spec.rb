require "rails_helper"

RSpec.describe "Homes", type: :system do
  context "on top page" do
    before do
      visit root_path
    end
    it "is on root page" do
      expect(current_path).to eq root_path
    end
  end
  context "on about page" do
    before do 
      visit about_path
    end
    it "is on about page" do
      expect(current_path).to eq about_path
    end
  end
end
require "rails_helper"

RSpec.describe "Homes", type: :system do
  context "on top page" do
    it "has 'TOP PAGE'" do
      visit root_path
      expect(page).to have_content "TOP PAGE"
    end
  end
  context "on about page" do
    it "has 'About'" do
      visit about_path
      expect(page).to have_content "ABOUT PAGE"
    end
  end
  context "on howto page" do
    it "has 'HOW TO PAGE" do
      visit howto_path
      expect(page).to have_content "HOW TO PAGE"
    end
  end
end
require "rails_helper"

RSpec.describe "footer", type: :system do
	context "on footer content" do
		before do
			visit root_path
		end
		it "has logo copyright content" do
			expect(page).to have_content "Logo made by DesignEvo free logo creator"
		end
		it "has access to logo maker cite" do
			expect(page).to have_selector "a[href='https://www.designevo.com/logo-maker/']", text: "DesignEvo free logo creator"
			expect(page).to have_selector "a[title='Free Online Logo Maker']", text: "DesignEvo free logo creator"
		end
	end
end
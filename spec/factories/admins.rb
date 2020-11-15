FactoryBot.define do
  factory :admin1, class: "Admin" do
    email { "admin1@com" }
    password { "testtest" }
    password_confirmation { "testtest" }
  end
end

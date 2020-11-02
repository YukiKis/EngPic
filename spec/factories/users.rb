FactoryBot.define do
  factory :user1, class: "User" do
    name { "yuki" }
    introduction { "Hello" }
    email { "yuki@com" }
    password { "testtest" }
    password_confirmation { "testtest" }
  end
end

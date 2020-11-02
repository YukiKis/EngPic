FactoryBot.define do
  factory :user1, class: "User" do
    name { "yuki" }
    introduction { "Hello" }
    email { "yuki@com" }
    password { "testtest" }
    password_confirmation { "testtest" }
  end
  
  factory :user2, class: "User" do
    name { "nana" }
    introduction { "Beginner of English" }
    email { "nana@com" }
    password { "testtest" }
    password_confirmation { "testtest" }
  end

end

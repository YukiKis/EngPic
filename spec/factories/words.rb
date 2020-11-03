FactoryBot.define do
  factory :word1, class: "Word" do
    name { "doll" }
    meaning { "人形" }
    sentence { "I bought a doll yesterday" }
    image_id { open("./app/assets/images/noimage.jpg") }
  end
end

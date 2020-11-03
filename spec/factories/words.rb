FactoryBot.define do
  factory :word1, class: "Word" do
    name { "doll" }
    meaning { "人形" }
    sentence { "I bought a doll yesterday" }
    image_id { open("./app/assets/images/noimage.jpg") }
  end
  
  factory :word2, class: "Word" do
    name { "book" }
    meaning { "本" }
    sentence { "I have a book yesterday" }
    image_id { open("./app/assets/images/noimage.jpg") }
  end
end

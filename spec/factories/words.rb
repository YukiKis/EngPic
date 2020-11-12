FactoryBot.define do
  factory :word1, class: "Word" do
    name { "doll" }
    meaning { "人形" }
    sentence { "I bought a doll yesterday" }
    tag_list { ["doll", "toy"] }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/noimage.jpg')) }
  end
  
  factory :word2, class: "Word" do
    name { "book" }
    meaning { "本" }
    sentence { "I have a book yesterday" }
    tag_list { ["book", "new"] }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/noimage.jpg')) }
  end
  
  factory :word3, class: "Word" do
    name { "doll" }
    meaning { "人形" }
    sentence { "I hate this doll" }
    tag_list { [ "doll", "disgusting" ]}
    image{ Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/factories/noimage.jpg")) }
  end
  
  factory :word4, class: "Word" do
    name { "doll" }
    meaning { "人形" }
    sentence { "I hate this doll" }
    tag_list { [ "doll", "disgusting" ]}
    image{ Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/factories/noimage.jpg")) }
  end
  
  factory :word5, class: "Word" do
    name { "doll" }
    meaning { "人形" }
    sentence { "I hate this doll" }
    tag_list { [ "doll", "disgusting" ]}
    image{ Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/factories/noimage.jpg")) }
  end
end

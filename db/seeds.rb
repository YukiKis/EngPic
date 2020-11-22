# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# User.create([{
# 	name: "yuki",
# 	email: "yuki@com",
# 	password: "testtest",
# },
# {
# 	name: "nana",
# 	email: "nana@com",
# 	password: "testtest",
# }]
# )
Admin.create({
  email: 'yuki@com',
  password: 'testtest',
  password_confirmation: 'testtest'
})

100.times do |n|
  User.create({
  name: Faker::Name.name,
  email: Faker::Internet.email + "#{ n }",
  password: "testtest",
  password_confirmation: "testtest"
})
end

250.times do |n|
  Word.create({
    image: open("#{ Rails.root }/app/assets/images/logo.jpg"),
    user_id: (1..100).to_a.shuffle[0],
    name: Faker::Game.title,
    meaning: Faker::JapaneseMedia::OnePiece.character,
    sentence: Faker::Game.genre,
    tag_list: Faker::Game.platform
})
end
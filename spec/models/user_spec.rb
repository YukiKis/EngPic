require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1){ build(:user1) }
  let(:user2){ create(:user1) }
  let(:user3){ create(:user2) }
  context "on user validation" do
    it "has many active_relationship" do
      expect(User.reflect_on_association(:active_relationships).macro).to eq :has_many
    end
    it "has many_passive_relationships" do
      expect(User.reflect_on_association(:passive_relationships).macro).to eq :has_many
    end
    it "has many followers" do
      expect(User.reflect_on_association(:followers).macro).to eq :has_many
    end
    it "has many followings" do
      expect(User.reflect_on_association(:followings).macro).to eq :has_many
    end
    it "has_one dictionary" do
      expect(User.reflect_on_association(:dictionary).macro).to eq :has_one
    end
    it "has_many words" do
      expect(User.reflect_on_association(:words).macro).to eq :has_many
    end
    it "is valid" do
      expect(user1).to be_valid
    end
    it "is invalid without name" do
      user1.name = ""
      expect(user1).to be_invalid
    end
    it "is invalid if name is too short" do
      user1.name = "a"
      expect(user1).to be_invalid
    end
    it "is invalid if name is too long" do
      user1.name = "a" * 100
      expect(user1).to be_invalid
    end
    it "is invalid if introduction is too long" do
      user1.introduction = "a" * 101
      expect(user1).to be_invalid 
    end
    it "is invalid without email" do
      user1.email = ""
      expect(user1).to be_invalid
    end
    it "is invalid without password" do
      user1.password = ""
      expect(user1).to be_invalid
    end
    it "can follow other user" do
      expect{ user2.follow(user3) }.to change{ user2.followings.count }.by(1)
    end
    it "can unfollow other user" do
      user2.follow(user3)
      expect{ user2.unfollow(user3) }.to change{ user2.followings.count }.from(1).to(0)
    end
    it "can check whether following other user or not" do
      expect(user2.following?(user3)).to be false
      user2.follow(user3)
      expect(user2.following?(user3)).to be true
      user2.unfollow(user3)
      expect(user2.following?(user3)).to be false
    end
    it "can scope by active users" do
      user2.is_active = false
      user2.save
      expect(User.active).to eq [user3]
    end
    it "can scope by those who registered today" do
      user2.created_at = Date.yesterday
      user2.save
      expect(User.today).to eq [user3]
    end
  end
end

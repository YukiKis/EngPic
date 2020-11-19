class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_one :dictionary, dependent: :destroy
  has_many :words
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id"
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :followings, through: :active_relationships, source: :followed
  attachment :image

  validates :name, presence: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 100 }
  scope :today, ->(){ where("created_at >= ?", Date.today) }
  
  def follow(user)
    self.active_relationships.create(followed: user)
  end
  
  def unfollow(user)
    self.active_relationships.find_by(followed: user).destroy
  end
  
  def following?(user)
    self.followings.include?(user)
  end
end

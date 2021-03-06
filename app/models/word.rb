class Word < ApplicationRecord
  belongs_to :user
  has_many :items
  has_many :dictionaries, through: :items
  acts_as_taggable_on :tags
  
  attachment :image

  validates :name, presence: true
  validates :meaning, presence: true
  validates :image, presence: true
  validates :tag_list, length: { maximum: 7 }
  
  scope :by_same_name, ->(name){ where("words.name LIKE ?", "%#{ name }") }
  scope :by_same_meaning, ->(meaning){ where("meaning LIKE ?", "%#{ meaning }") }
  scope :today, ->(){ where("created_at >= ?", Date.today) }
  scope :active, ->(){ joins(:user).where(users: { is_active: true }) }
end

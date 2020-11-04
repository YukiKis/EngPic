class Word < ApplicationRecord
  belongs_to :user
  has_many :items
  has_many :dictionaries, through: :items
  acts_as_taggable
  
  attachment :image

  validates :name, presence: true
  validates :meaning, presence: true
  validates :image, presence: true
  
end

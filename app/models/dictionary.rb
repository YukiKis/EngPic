class Dictionary < ApplicationRecord
  belongs_to :user
  has_many :items
  has_many :words, through: :items
end

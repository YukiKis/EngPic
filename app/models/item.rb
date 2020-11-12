class Item < ApplicationRecord
  belongs_to :word
  belongs_to :dictionary
  
  validates :word_id, presence: true
  validates :dictionary, presence: true
end

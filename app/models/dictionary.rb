class Dictionary < ApplicationRecord
  belongs_to :user
  has_many :items
  has_many :words, through: :items
  
  def add(word)
    self.items.create(word: word)
  end
  
  def remove(word)
    self.items.find_by(word: word).destroy
  end
end

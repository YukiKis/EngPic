class Dictionary < ApplicationRecord
  belongs_to :user
  has_many :items
  has_many :words, through: :items 
  
  def add(word)
    unless self.words.include?(word)
      self.items.create(word: word)
    end
  end
  
  def remove(word)
    if self.words.include?(word)
      self.items.find_by(word: word).destroy
    end
  end
end

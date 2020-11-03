class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :dictionary
  has_many :words

  attachment :image
  
  validates :name, presence: true, length: { in: 2..20 }
end

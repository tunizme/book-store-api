class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  has_one :cart
  has_many :orders
end

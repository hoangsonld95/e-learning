class User < ApplicationRecord

  # Standardize email by downcasing
  before_save { self.email = email.downcase }
  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

end

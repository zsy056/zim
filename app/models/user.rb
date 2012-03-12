# == Schema Information
#
# Table name: users
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  utype           :integer(4)      default(0)
#

class User < ActiveRecord::Base
  has_many :contacts, foreign_key: "owner_id", dependent: :destroy
  has_many :contact_users, through: :contacts, source: :contact
  
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: valid_email_regex }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6}

  def is_contact?(other_user)
    contacts.find_by_contact_id(other_user.id)
  end

  def add_contact!(other_user)
    contacts.create!(contact_id: other_user.id)
  end

  def rm_contact!(other_user)
    contacts.find_by_contact_id(other_user.id).destroy
  end
  
  def set_admin!
    self.utype = 1
  end

  def admin?
    self.utype == 1
  end
  
  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end

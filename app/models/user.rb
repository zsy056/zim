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
  has_many(:contacts, foreign_key: "owner_id", dependent: :destroy)
  has_many(:contact_users, through: :contacts, source: :contact)
  has_many(:contact_groups, foreign_key: "owner_id", dependent: :destroy)
  
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: valid_email_regex }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6}

  # Methods about contacts
  def is_contact?(other_user)
    contacts.find_by_contact_id(other_user.id)
  end

  def add_contact!(other_user, group_name_to_add, new_contact_alias)
    group = contact_groups.find_by_group_name(group_name_to_add)
    group_id = group ? group.id : -1;
    contacts.create!(contact_id: other_user.id, contact_group: group_id, contact_alias: new_contact_alias)
  end

  def rm_contact!(other_user)
    contacts.find_by_contact_id(other_user.id).destroy
  end
  
  # Methods about contact groups
  def has_group?(q_group_name)
    contact_groups.find_by_group_name(q_group_name)
  end
  
  def add_contact_group!(new_group_name)
    contact_groups.create!(group_name: new_group_name)
  end
  
  def rm_contact_group!(group_name_to_rm)
    contact_groups.find_by_group_name(group_name_to_rm).destory
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

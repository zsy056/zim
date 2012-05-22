# == Schema Information
#
# Table name: contacts
#
#  id            :integer(4)      not null, primary key
#  owner_id      :integer(4)
#  contact_id    :integer(4)
#  contact_group :integer(4)      default(-1)
#  contact_alias :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class Contact < ActiveRecord::Base
  attr_accessible :contact_id, :contact_alias, :contact_group
  
  belongs_to :owner, class_name: "User"
  belongs_to :contact, class_name: "User"
  belongs_to :group, class_name: "ContactGroup"
  
  validates :owner_id, presence: true
  validates :contact_id, presence: true
end

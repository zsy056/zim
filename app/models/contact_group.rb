# == Schema Information
#
# Table name: contact_groups
#
#  id         :integer(4)      not null, primary key
#  owner_id   :integer(4)
#  group_name :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class ContactGroup < ActiveRecord::Base
  attr_accessible :group_name
  
  belongs_to :owner, class_name: "User"
  
  validates :owner_id, presence: true
  
  def group_name
    read_attribute(:group_name) || 'Default'
  end
end

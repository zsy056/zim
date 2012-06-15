# == Schema Information
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  from       :integer(4)
#  to         :integer(4)
#  is_sent    :boolean(1)
#  content    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Message < ActiveRecord::Base
  attr_accessible :content, :from, :to, :is_sent
  
  belongs_to :from_user, class_name: "User", :inverse_of => :sent_messages, :foreign_key => 'from'
  belongs_to :to_user, class_name: "User", :inverse_of => :recv_messages, :foreign_key => 'to'
  
  validates :from, presence: true
  validates :to, presence: true
  validates :is_sent, :inclusion => { :in => [true, false] }
  validates :content, presence: true

end

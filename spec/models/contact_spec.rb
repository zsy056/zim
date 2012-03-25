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

require 'spec_helper'

describe Contact do
  pending "add some examples to (or delete) #{__FILE__}"
end

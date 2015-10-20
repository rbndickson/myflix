require 'spec_helper'

describe Relationship do
  it { should belong_to(:follower).class_name('User') }
  it { should belong_to(:leader).class_name('User') }
  it { should validate_presence_of(:follower_id) }
  it { should validate_presence_of(:leader_id) }
end

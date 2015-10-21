require 'spec_helper'

describe Relationship do
  it { should belong_to(:follower).class_name('User') }
  it { should belong_to(:leader).class_name('User') }
end

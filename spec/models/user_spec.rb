require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should have_many(:queue_items).order('position') }

  describe "#video_queued?" do
    it "returns true when the user has already queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.video_queued?(video)).to be true
    end

    it "returns false when the user has already queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.video_queued?(video)).to be false
    end
  end
end

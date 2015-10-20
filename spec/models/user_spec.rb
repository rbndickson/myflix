require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should have_many(:queue_items).order('position') }
  it { should have_many(:reviews).order('created_at DESC') }

  describe "#video_queued?" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "returns true when the user has already queued the video" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.video_queued?(video)).to be true
    end

    it "returns false when the user has not already queued the video" do
      expect(user.video_queued?(video)).to be false
    end
  end

  describe "#follow" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    context "with non duplicates" do
      before { alice.follow(bob) }

      it "creates a new record" do
        expect(Relationship.count).to eq(1)
      end

      it "creates a follower for the leader" do
        expect(bob.followers.first).to eq(alice)
      end

      it "creates a leader for the follower" do
        expect(alice.leaders.first).to eq(bob)
      end

      it "does not add the inverse follow relationships" do
        expect(alice.followers).to be_empty
        expect(bob.leaders).to be_empty
      end
    end

    context "with duplicates" do
      it "does not add a new record" do
        2.times { alice.follow(bob) }
        expect(Relationship.count).to eq(1)
      end
    end
  end

  describe "#unfollow" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    it "destroys the record" do
      alice.follow(bob)
      expect(Relationship.count).to eq(1)
      alice.unfollow(bob)
      expect(Relationship.count).to eq(0)
    end
  end
end

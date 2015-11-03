require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should have_many(:queue_items).order('position') }
  it { should have_many(:reviews).order('created_at DESC') }

  it_behaves_like "a random token is generated" do
    let(:object) { Fabricate(:user) }
  end

  describe "#video_queued?" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "returns true when the user has already queued the video" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.video_queued?(video)).to be true
    end

    it "returns false when the user has not already queued the video" do
      expect(user.video_queued?(video)).to be_falsey
    end
  end

  describe "#follow!" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    context "with non duplicates" do
      before { alice.follow!(bob) }

      it "creates a new record" do
        expect(Relationship.count).to eq(1)
      end

      it "creates a following relationship" do
        expect(bob.followers.first).to eq(alice)
      end

      it "creates a leading relationship" do
        expect(alice.leaders.first).to eq(bob)
      end

      it "does not add the inverse follow relationships" do
        expect(alice.followers).to be_empty
        expect(bob.leaders).to be_empty
      end

      it "does not follow oneself" do
        expect(alice.follow!(alice)).to be_falsey
      end
    end

    context "with duplicates" do
      it "does not add a new record" do
        Fabricate(:relationship, follower: alice, leader: bob)
        alice.follow!(bob)
        expect(Relationship.count).to eq(1)
      end
    end
  end

  describe "#unfollow" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    it "destroys the record" do
      Fabricate(:relationship, follower: alice, leader: bob)
      expect{alice.unfollow(bob)}.to change{Relationship.count}.by(-1)
    end
  end

  describe "#follows?" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    it "returns true if the user follows the given other user" do
      Fabricate(:relationship, follower: alice, leader: bob)
      expect(alice.follows?(bob)).to be true
    end

    it "returns false if the user does not follow the given other user" do
      expect(alice.follows?(bob)).to be false
    end
  end
end

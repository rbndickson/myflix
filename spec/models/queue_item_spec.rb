require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }

  it { should delegate_method(:category).to(:video) }
  it { should delegate_method(:title).to(:video).with_prefix(:video) }

  describe '#category_name' do
    it "returns the category name of the associated video" do
      action = Fabricate(:category, name:'action')
      bond = Fabricate(:video, category: action)
      queue_item = Fabricate(:queue_item, video: bond)
      expect(queue_item.category_name).to eq('action')
    end
  end

  describe '#rating' do
    let(:user) { user = Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "returns the user's rating of the associated video if there is a rating" do
      review = Fabricate(:review, video: video, user: user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(review.rating)
    end

    it "returns no rating if there is no rating" do
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to be_nil
    end
  end
end

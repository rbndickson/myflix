require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }

  describe ".search_by_title" do

    it "returns an empty array if there are no matches" do
      superman = Video.create(title: "Superman", description: "Flying hero!")
      spiderman = Video.create(title: "Spiderman", description: "Spider hero!")
      expect(Video.search_by_title("amazing")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      superman = Video.create(title: "Superman", description: "Flying hero!")
      spiderman = Video.create(title: "Spiderman", description: "Spider hero!")
      expect(Video.search_by_title("Spiderman")).to eq([spiderman])
    end

    it "returns an array of one video for a partial match" do
      superman = Video.create(title: "Superman", description: "Flying hero!")
      spiderman = Video.create(title: "Spiderman", description: "Spider hero!")
      expect(Video.search_by_title("Super")).to eq([superman])
    end

    it "returns an array of all matches ordered by created_at" do
      superman = Video.create(title: "Superman", description: "Flying hero!", created_at: 1.day.ago)
      spiderman = Video.create(title: "Spiderman", description: "Spider hero!")
      expect(Video.search_by_title("man")).to eq([spiderman, superman])
    end

    it "returns an empty array when searching for a blank string" do
      superman = Video.create(title: "Superman", description: "Flying hero!")
      spiderman = Video.create(title: "Spiderman", description: "Spider hero!")
      expect(Video.search_by_title("")).to eq([])
    end

  end

  describe "#average_rating" do
    it "should return No reviews yet when there are no reviews" do
      video = Fabricate(:video)
      expect(video.average_rating).to eq(nil)
    end

    it "should return the average of the ratings when there are reviews" do
      video = Fabricate(:video)
      review1 = Fabricate(:review, rating: 4, video: video)
      review2 = Fabricate(:review, rating: 5, video: video)
      expect(video.average_rating).to eq(4.5)
    end
  end

end

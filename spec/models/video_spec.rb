require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

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

end

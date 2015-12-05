require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }

  describe ".search_by_title" do
    it "returns an empty array if there are no matches" do
      Fabricate(:video, title: "Superman")
      Fabricate(:video, title: "Spiderman")
      expect(Video.search_by_title("amazing")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      Fabricate(:video, title: "Superman")
      spiderman = Fabricate(:video, title: "Spiderman")
      expect(Video.search_by_title("Spiderman")).to eq([spiderman])
    end

    it "returns an array of one video for a partial match" do
      Fabricate(:video, title: "Superman")
      spiderman = Fabricate(:video, title: "Spiderman")
      expect(Video.search_by_title("Spi")).to eq([spiderman])
    end

    it "returns an array of all matches ordered by created_at" do
      superman = Fabricate(:video, title: "Superman")
      spiderman = Fabricate(:video, title: "Spiderman")
      expect(Video.search_by_title("man")).to eq([spiderman, superman])
    end

    it "returns an empty array when searching for a blank string" do
      Fabricate(:video, title: "Superman")
      Fabricate(:video, title: "Spiderman")
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe "#average_rating" do
    it "returns nil when there are no reviews" do
      video = Fabricate(:video)
      expect(video.average_rating).to eq(nil)
    end

    it "returns the average of the ratings when there are reviews" do
      video = Fabricate(:video)
      Fabricate(:review, rating: 4, video: video)
      Fabricate(:review, rating: 5, video: video)
      expect(video.average_rating).to eq(4.5)
    end
  end

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        Fabricate(:video, title: "Futurama")
        Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end

      context "with title and description" do
        it "returns an array of many videos based for title and description match" do
          star_wars = Fabricate(:video, title: "Star Wars")
          about_sun = Fabricate(:video, description: "sun is a star")
          refresh_index

          expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
        end
      end

      context "multiple words must match" do
        it "returns an array of videos where 2 words match title" do
          star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
          star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
          Fabricate(:video, title: "Bride Wars")
          Fabricate(:video, title: "Star Trek")
          refresh_index

          expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
        end
      end

      context "with title, description and reviews" do
        it 'returns an an empty array for no match with reviews option' do
          Fabricate(:video, title: "Star Wars")
          batman = Fabricate(:video, title: "Batman")
          Fabricate(:review, video: batman, content: "Such a star movie!")
          refresh_index

          expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
        end

        it 'returns an array of many videos with relevance title > description > review' do
          star_wars = Fabricate(:video, title: "Star Wars")
          about_sun = Fabricate(:video, description: "the sun is a star!")
          batman    = Fabricate(:video, title: "Batman")
          Fabricate(:review, video: batman, content: "Such a star movie!")
          refresh_index

          expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
        end
      end
    end
  end
end

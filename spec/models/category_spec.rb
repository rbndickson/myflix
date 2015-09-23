require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos' do
    let(:hero_movies) { Category.create(name:"Hero Movies") }

    it 'returns an empty array if a category has no videos' do
      expect(hero_movies.recent_videos).to eq([])
    end

    it 'returns the videos in reverse chronological order' do
      superman = Fabricate(:video, category: hero_movies)
      spiderman = Fabricate(:video, category: hero_movies)
      batman = Fabricate(:video, category: hero_movies)
      expect(hero_movies.recent_videos).to eq([batman, spiderman, superman])
    end

    it 'returns all videos if there are less than 6 videos' do
      3.times { Fabricate(:video, category: hero_movies) }
      expect(hero_movies.recent_videos.count).to eq(3)
    end

    it 'returns six videos if there are 6 or more videos' do
      10.times { Fabricate(:video, category: hero_movies) }
      expect(hero_movies.recent_videos.count).to eq(6)
    end

    it 'returns the most recent 6 videos' do
      10.times { Fabricate(:video, category: hero_movies) }
      batman = Fabricate(:video, category: hero_movies, created_at: 1.day.ago)
      expect(hero_movies.recent_videos).not_to include(batman)
    end
  end
end

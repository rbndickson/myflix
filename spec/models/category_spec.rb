require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe '#recent_videos' do
    it 'returns an empty array if there are no videos' do
      hero_movies = Category.create(name:"Hero Movies")

      expect(hero_movies.recent_videos).to eq([])
    end

    it 'returns the videos in reverse chronological order' do
      hero_movies = Category.create(name:"Hero Movies")
      superman = Video.create(title: "Superman", description: "Flying hero!", category: hero_movies)
      spiderman = Video.create(title: "Spiderman", description: "Spider hero!", category: hero_movies)
      batman = Video.create(title: "Batman", description: "Bat hero!", category: hero_movies)

      expect(hero_movies.recent_videos).to eq([batman, spiderman, superman])
    end

    it 'returns all videos if there are less than 6 videos' do
      hero_movies = Category.create(name:"Hero Movies")
      superman = Video.create(title: "Superman", description: "Flying hero!", category: hero_movies)
      spiderman = Video.create(title: "Spiderman", description: "Spider hero!", category: hero_movies)
      batman = Video.create(title: "Batman", description: "Bat hero!", category: hero_movies)

      expect(hero_movies.recent_videos.count).to eq(3)
    end

    it 'returns six videos if there are 6 or more videos' do
      hero_movies = Category.create(name:"Hero Movies")
      10.times { Video.create(title: "Somethingman", description: "Something hero!", category: hero_movies) }

      expect(hero_movies.recent_videos.count).to eq(6)
    end

    it 'returns the most recent 6 videos' do
      hero_movies = Category.create(name:"Hero Movies")
      10.times { Video.create(title: "Somethingman", description: "Something hero!", category: hero_movies) }
      superman = Video.create(title: "Superman", description: "Flying hero!", category: hero_movies, created_at: 1.day.ago)

      expect(hero_movies.recent_videos).not_to include(superman)
    end
  end
end

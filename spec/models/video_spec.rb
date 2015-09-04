require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(
      title: "The Amazing Race",
      description: "Contestants race around the world"
    )
    video.save
    expect(Video.first).to eq(video)
  end
end

describe Video do
  it "belongs to category" do
    reality = Category.create(name: "Reality")
    amazing_race = Video.create(
      title: "The Amazing Race",
      description: "Contestants race around the world",
      category: reality
    )
    expect(amazing_race.category).to eq(reality)
  end
end

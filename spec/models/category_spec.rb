require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Reality")
    category.save
    expect(Category.first.name).to eq("Reality")
  end

  it "has many videos" do
    reality = Category.create(name: "Reality")
    amazing_race = Video.create(
      title: "The Amazing Race",
      description: "Racing around the world",
      category: reality
    )
    top_chef = Video.create(
      title: "Top Chef",
      description: "Chef cook off",
      category: reality
    )
    expect(reality.videos).to eq([amazing_race, top_chef])
  end
end

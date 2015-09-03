# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: "Avatar - The Last Airbender", description: "The Avatar must master all 4 elements on his quest to save the world", small_cover_url:"avatar.jpg", large_cover_url: "avatar_large.jpg")
Video.create(title: "The Office", description: "Comedy about British office life", small_cover_url:"office.jpg", large_cover_url: "office_large.jpg")
Video.create(title: "The Amazing Race", description: "Contestants race around the world completing various challenges", small_cover_url:"amazing_race.jpg", large_cover_url: "amazing_race_large.jpg")

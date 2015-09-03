# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedy = Category.create(name: "Comedy")
reality = Category.create(name: "Reality")
animation = Category.create(name: "Animation")

Video.create(title: "The Office", description: "Comedy about British office life", small_cover_url:"/tmp/office.jpg", large_cover_url: "/tmp/office_large.jpg", category_id: comedy.id)
Video.create(title: "The Amazing Race", description: "Contestants race around the world completing various challenges", small_cover_url:"/tmp/amazing_race.jpg", large_cover_url: "/tmp/amazing_race_large.jpg", category_id: reality.id)
Video.create(title: "Avatar - The Last Airbender", description: "The Avatar must master all 4 elements on his quest to save the world", small_cover_url:"/tmp/avatar.jpg", large_cover_url: "/tmp/avatar_large.jpg", category_id: animation.id)
Video.create(title: "South Park", description: "Four kids struggle with the pains of growing up", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/south_park_large.jpg", category_id: comedy.id)

# Image sizes: 166 * 236, 665 * 375

alice = User.create!(
  email: "alice@example.com",
  password: 'password',
  full_name: 'Alice Alicia'
)
bob = User.create!(
  email: "bob@example.com",
  password: 'password',
  full_name: 'Bob Bobson'
)

comedy = Category.create!(name: 'Comedy')
reality = Category.create!(name: 'Reality')
animation = Category.create!(name: 'Animation')

# video_list = [
#   ['Avatar', 'The Avatar saves the world', animation],
#   ['South Park', 'Four kids struggle with the pains of growing up', comedy],
#   ['monk', 'I have no idea!', comedy],
#   ['Family Guy', 'A family with a talking dog and a talking baby', comedy],
#   ['Futurama', 'Robots, aliens and humans live together in the future', comedy],
#   ['Blackadder', 'Comedy through history', comedy],
#   ['Red Dwarf', 'Space adventures', comedy],
# ]
#
# video_list.each do |title, description, category|
#   Video.create!(
#     title: title,
#     description: description,
#     small_cover_url: "/tmp/#{title.downcase.tr(" ", "_")}.jpg",
#     large_cover_url: "/tmp/#{title.downcase.tr(" ", "_")}_large.jpg",
#     category: category
#   )
# end
#
# the_office = Video.create!(
#   title: 'The Office',
#   description: 'Comedy about British office life',
#   small_cover_url: '/tmp/office.jpg',
#   large_cover_url: '/tmp/office_large.jpg',
#   category: comedy
# )
# the_amazing_race = Video.create!(
#   title: 'The Amazing Race',
#   description: 'Contestants race around the world completing challenges',
#   small_cover_url: '/tmp/amazing_race.jpg',
#   large_cover_url: '/tmp/amazing_race_large.jpg',
#   category: reality
# )
#
# Review.create!(
#   user: alice,
#   video: the_office,
#   rating: 5,
#   content: "Very funny indeed!"
#   )
#
# Review.create!(
#   user: bob,
#   video: the_office,
#   rating: 2,
#   content: "Not very funny..."
#   )
#
# QueueItem.create!(user: alice, video: the_office, position: 1)
# QueueItem.create!(user: alice, video: the_amazing_race, position: 2)
#
# Relationship.create!(follower: alice, leader: bob)

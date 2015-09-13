# Image sizes: 166 * 236, 665 * 375

comedy = Category.create!(name: 'Comedy')
reality = Category.create!(name: 'Reality')
animation = Category.create!(name: 'Animation')

the_office = Video.create!(
  title: 'The Office',
  description: 'Comedy about British office life',
  small_cover_url: '/tmp/office.jpg',
  large_cover_url: '/tmp/office_large.jpg',
  category: comedy
)

the_amazing_race = Video.create!(
  title: 'The Amazing Race',
  description: 'Contestants race around the world completing various challenges',
  small_cover_url: '/tmp/amazing_race.jpg',
  large_cover_url: '/tmp/amazing_race_large.jpg',
  category: reality
)

Video.create!(
  title: 'Avatar - The Last Airbender',
  description: 'The Avatar must master all 4 elements on his quest to save the world',
  small_cover_url: '/tmp/avatar.jpg',
  large_cover_url: '/tmp/avatar_large.jpg',
  category: animation
)

Video.create!(
  title: 'South Park',
  description: 'Four kids struggle with the pains of growing up',
  small_cover_url: '/tmp/south_park.jpg',
  large_cover_url: '/tmp/south_park_large.jpg',
  category: comedy
  )

Video.create!(
  title: 'Monk',
  description: 'I have no idea!',
  small_cover_url: '/tmp/monk.jpg',
  large_cover_url: '/tmp/monk_large.jpg',
  category: comedy
  )

Video.create!(
  title: 'Futurama',
  description: 'Robots, aliens and humans live together in the future',
  small_cover_url: '/tmp/futurama.jpg',
  large_cover_url: '/tmp/futurama_large.jpg',
  category: comedy
  )

Video.create!(
  title: 'Family Guy',
  description: 'A crazy family with a talking dog and talking baby',
  small_cover_url: '/tmp/family_guy.jpg',
  large_cover_url: '/tmp/family_guy_large.jpg',
  category: comedy
  )

Video.create!(
  title: 'Blackadder',
  description: 'Comedy through history',
  small_cover_url: '/tmp/blackadder.jpg',
  large_cover_url: '/tmp/blackadder_large.jpg',
  category: comedy
  )

Video.create!(
  title: 'Red Dwarf',
  description: 'Space adventures',
  small_cover_url: '/tmp/red_dwarf.jpg',
  large_cover_url: '/tmp/red_dwarf_large.jpg',
  category: comedy
  )

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

Review.create!(
  user: alice,
  video: the_office,
  rating: 5,
  content: "Very funny indeed!"
  )

Review.create!(
  user: bob,
  video: the_office,
  rating: 2,
  content: "Not very funny..."
  )

QueueItem.create!(
  user: alice,
  video: the_office,
  position: 1
)

QueueItem.create!(
  user: alice,
  video: the_amazing_race,
  position: 2
)

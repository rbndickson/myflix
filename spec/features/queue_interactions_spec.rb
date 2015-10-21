require 'spec_helper'

feature 'user interacts with my queue' do
  scenario "user adds and reorders videos in the queue" do
    comedy = Fabricate(:category, name: 'Comedy')
    red_dwarf = Fabricate(:video, title: 'Red Dwarf', category: comedy)
    the_office = Fabricate(:video, title: 'The Office', category: comedy)
    south_park = Fabricate(:video, title: 'South Park', category: comedy)

    sign_in

    add_video_to_queue(red_dwarf)
    expect_video_to_be_in_queue(red_dwarf)

    visit video_path(red_dwarf)
    expect_link_not_to_be_seen('+ My Queue')

    add_video_to_queue(the_office)
    add_video_to_queue(south_park)

    set_video_position(red_dwarf, 3)
    set_video_position(the_office, 1)
    set_video_position(south_park, 2)

    press_update_queue_button

    expect_video_position(the_office, 1)
    expect_video_position(south_park, 2)
    expect_video_position(red_dwarf, 3)
  end

  def add_video_to_queue(video)
    visit home_path
    visit_video_page(video)
    click_link "+ My Queue"
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_not_to_be_seen(link_text)
    expect(page).not_to have_content(link_text)
  end

  def set_video_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end

  def press_update_queue_button
    click_button "Update Instant Queue"
  end

  def expect_video_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq position.to_s
  end
end

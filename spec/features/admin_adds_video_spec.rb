require "spec_helper"

feature "adding a video" do
  scenario "admin adds video successfully" do
    admin = Fabricate(:admin)
    Fabricate(:category, name: "Reality")
    sign_in(admin)
    visit new_admin_video_path

    fill_in "Title", with: "Amazing Race"
    select "Reality", from: "Category"
    fill_in "Description", with: "A race around the world"
    attach_file "Large cover", "spec/support/uploads/amazing_race_large.jpg"
    attach_file "Small cover", "spec/support/uploads/amazing_race.jpg"
    fill_in "Video URL", with: "http://www.example.com/amazing_video.mp4"
    click_button "Add Video"

    sign_out
    sign_in

    visit video_path(Video.first)

    expect(page).to have_selector("img[src='/uploads/amazing_race_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/amazing_video.mp4']")
  end
end

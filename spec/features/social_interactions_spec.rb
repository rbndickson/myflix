require 'spec_helper'

feature 'user interacts with social features' do
  scenario "user " do
    comedy = Fabricate(:category, name: 'Comedy')
    video = Fabricate(:video, category: comedy)
    alice = Fabricate(:user)
    Fabricate(:review, video: video, user: alice)

    sign_in
    visit home_path
    visit_video_page(video)
    click_link alice.full_name
    click_link 'Follow'

    expect(page).to have_content('People I Follow')
    expect_user_to_be_in_followers(alice)

    unfollow(alice)

    expect_user_to_not_be_in_followers(alice)
  end

  def unfollow(user)
    find("a[href='/relationships/#{user.id}']").click
  end

  def expect_user_to_be_in_followers(user)
    within("//section[@class='people']") do
      page.should have_content(user.full_name)
    end
  end

  def expect_user_to_not_be_in_followers(user)
    within("//section[@class='people']") do
      page.should have_no_content(user.full_name)
    end
  end
end

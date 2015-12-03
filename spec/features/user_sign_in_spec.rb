require 'spec_helper'

feature 'User signs in' do
  scenario "with existing account" do
    alice = Fabricate(:user)
    sign_in(alice)

    expect(page).to have_content("Welcome")
  end

  scenario "with deactivated user" do
    alice = Fabricate(:user, active: false)
    sign_in(alice)

    expect(page).not_to have_content("Welcome")
    expect(page).to have_content("Your account has been suspended, please contact customer service")
  end
end

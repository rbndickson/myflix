require 'spec_helper'

feature 'User signs in' do
  scenario "with existing username" do
    alice = Fabricate(:user)
    visit sign_in_path
    fill_in "email", with: alice.email
    fill_in "password", with: alice.password
    click_button "Sign In"

    expect(page).to have_content("Welcome")
  end
end

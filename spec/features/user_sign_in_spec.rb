require 'spec_helper'

feature 'User signs in' do
  scenario "with existing account" do
    alice = Fabricate(:user)
    sign_in(alice)

    expect(page).to have_content("Welcome")
  end
end

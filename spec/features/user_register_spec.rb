require 'spec_helper'

feature "registration" do
  scenario "user creates account and logs in" do
    register_alice
    visit sign_in_path
    fill_in "email", with: "alice@example.com"
    fill_in "password", with: "password"
    click_button "Sign In"
    expect(page).to have_content("Welcome, #{}")
  end
end

feature 'emailer' do
  background do
    clear_emails
    register_alice
    open_email('alice@example.com')
  end

  scenario "testing for content" do
    expect(current_email).to have_content('Hi Alice Alicia, welcome to MyFlix')
  end
end

def register_alice
  visit root_path
  click_link "Sign Up Now!"
  fill_in "Email Address", with: "alice@example.com"
  fill_in "Password", with: "password"
  fill_in "Full Name", with: "Alice Alicia"
  click_button "Sign Up"
end

require 'spec_helper'

feature "password reset" do
  scenario "with existing user" do
    alice = Fabricate(:user, email: "alice@example.com", password: 'password')
    visit sign_in_path
    click_link "Forgot Password?"

    fill_in "Email Address", with: alice.email
    click_button "Send Email"

    open_email(alice.email)
    current_email.click_link 'Reset my password'
    fill_in "New Password", with: 'new_password'
    click_button "Reset Password"

    fill_in "email", with: alice.email
    fill_in "password", with: "new_password"
    click_button "Sign In"
    expect(page).to have_content("Welcome, #{alice.full_name}")
    clear_emails
  end
end

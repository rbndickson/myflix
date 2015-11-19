require 'spec_helper'

feature "registration", { js: true, vcr: true } do
  scenario "with valid user info and valid card" do
    visit register_path
    fill_in_valid_user_info
    fill_in_valid_card_details
    click_button "Sign Up"
    expect(page).to have_content("You have been registered, please sign in.")
    open_email('alice@example.com')
    expect(current_email).to have_content('Hi Alice Alicia, welcome to MyFlix')
    visit sign_in_path
    fill_in "email", with: "alice@example.com"
    fill_in "password", with: "password"
    click_button "Sign In"
    expect(page).to have_content("Welcome, Alice Alicia")
    clear_emails
  end

  scenario "with valid user info and invalid card" do
    visit register_path
    fill_in_valid_user_info
    fill_in_invalid_card_details
    click_button "Sign Up"
    expect(page).to have_content("Your card's security code is invalid.")
  end

  scenario "with valid user info and declined card" do
    visit register_path
    fill_in_valid_user_info
    fill_in_declined_card_details
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined.")
  end

  scenario "with invalid user info and valid card" do
    visit register_path
    fill_in_invalid_user_info
    fill_in_valid_card_details
    click_button "Sign Up"
    expect(page).to have_content("is too short (minimum is 6 characters)")
  end

  scenario "with invalid user info and invalid card" do
    visit register_path
    fill_in_invalid_user_info
    fill_in_invalid_card_details
    click_button "Sign Up"
    expect(page).to have_content("Your card's security code is invalid.")
  end

  scenario "with invalid user info and declined card" do
    visit register_path
    fill_in_invalid_user_info
    fill_in_declined_card_details
    click_button "Sign Up"
    expect(page).to have_content("is too short (minimum is 6 characters)")
  end
end

def fill_in_valid_user_info
  fill_in "Email Address", with: "alice@example.com"
  fill_in "Password", with: "password"
  fill_in "Full Name", with: "Alice Alicia"
end

def fill_in_invalid_user_info
  fill_in "Email Address", with: "alice@example.com"
  fill_in "Password", with: "pass"
  fill_in "Full Name", with: "Alice Alicia"
end

def fill_in_valid_card_details
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code", with: "123"
  select "7 - July", from: "date_month"
  select "2017", from: "date_year"
end

def fill_in_invalid_card_details
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code", with: "1"
  select "7 - July", from: "date_month"
  select "2017", from: "date_year"
end

def fill_in_declined_card_details
  fill_in "Credit Card Number", with: "4000000000000002"
  fill_in "Security Code", with: "123"
  select "7 - July", from: "date_month"
  select "2017", from: "date_year"
end

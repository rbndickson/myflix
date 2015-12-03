require 'spec_helper'

feature "admin sees payments" do
  background do
    alice = Fabricate(:user, email: "alice@example.com", full_name: "Alice Alicia")
    Fabricate(:payment, amount: 999, user: alice)
  end

  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice Alicia")
    expect(page).to have_content("alice@example.com")
  end

  scenario "user cannot see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Alice Alicia")
    expect(page).to have_content("You do not have access.")
  end
end

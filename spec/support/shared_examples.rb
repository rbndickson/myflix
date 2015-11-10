shared_examples "users must be signed in" do
  it "redirects to the sign in page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to(sign_in_path)
  end
end

shared_examples "admin is required" do
  it "redirects a regular user to the home page" do
    set_current_user
    action
    expect(response).to redirect_to(home_path)
  end
end

shared_examples "a random token is generated" do
  it "a random token is generated on creation" do
    expect(object.token).to be_present
  end
end

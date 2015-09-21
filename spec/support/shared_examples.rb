shared_examples "users must sign in" do
  it "redirects to the sign in page" do
    action
    expect(response).to redirect_to(sign_in_path)
  end
end

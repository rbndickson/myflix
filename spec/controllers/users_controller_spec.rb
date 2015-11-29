require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "GET new_with_invitation_token" do
    let(:invitation) { Fabricate(:invitation) }

    it "renders the new view template" do
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template(:new)
    end

    it "sets @user with recipient's email" do
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "assigns @invitation_token" do
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: '12345'
      expect(response).to redirect_to(expired_token_path)
    end
  end

  describe "POST create" do
    context "with successful user sign up" do
      it "redirects to the sign in path" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context "with failed user sign up" do
      it "renders the new template" do
        result = double(:sign_up_result, successful?: false, error_message: "Your card was declined")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
        expect(response).to render_template(:new)
      end

      it "sets the flash error message" do
        result = double(:sign_up_result, successful?: false, error_message: "Your card was declined")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
        expect(flash[:danger]).to eq("Your card was declined")
      end
    end
  end

  describe "GET show" do
    let(:user) { Fabricate(:user) }

    it_behaves_like "users must be signed in" do
      let(:action) {get :show, id: user }
    end

    it "assigns @user" do
      set_current_user
      get :show, id: user
      expect(assigns(:user)).to eq(user)
    end
  end
end

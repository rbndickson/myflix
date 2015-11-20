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
    context "when personal info and card are both valid" do
      let(:alice) { Fabricate(:user) }
      let(:charge) { double(:charge, successful?: true) }
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      it "creates a new user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in path" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to(sign_in_path)
      end

      let(:invitation) {
        Fabricate(
          :invitation,
          inviter: alice,
          recipient_email: 'joe@example.com'
        )
      }

      let(:post_create_with_invitation_token) { post :create,
        user: {
          email: 'joe@example.com',
          password: 'password',
          full_name: 'Joe Joe'
        },
        invitation_token: invitation.token
      }

      it "makes the user follow the inviter" do
        post_create_with_invitation_token
        joe = User.find_by(email: 'joe@example.com')
        expect(joe.follows?(alice)).to be_truthy
      end

      it "makes the inviter follow the user" do
        post_create_with_invitation_token
        joe = User.find_by(email: 'joe@example.com')
        expect(alice.follows?(joe)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        post_create_with_invitation_token
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with valid personal info but declined card" do
      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
        expect(response).to render_template(:new)
      end

      it "sets the flash error message" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
        expect(flash[:danger]).to be_present
      end
    end

    context "when the personal info is invalid" do
      it "does not create a new user" do
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: { password: "pass" }
      end

      it "renders the new template" do
        post :create, user: { password: "pass" }
        expect(response).to render_template(:new)
      end

      it "assigns @user" do
        post :create, user: { password: "pass" }
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "does not send an email" do
        ActionMailer::Base.deliveries.clear
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "email sending" do
      let(:charge) { double(:charge, successful?: true) }
      before { expect(Stripe::Charge).to receive(:create).and_return(charge) }
      after { ActionMailer::Base.deliveries.clear }
      let(:user_attributes) { Fabricate.attributes_for(:user) }

      it "sends an email to a user with valid inputs" do
        post :create, user: user_attributes
        expect(ActionMailer::Base.deliveries).to be_present
      end

      it "sends to the right recipient" do
        post :create, user: user_attributes
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([user_attributes[:email]])
      end

      it "sends the correct content" do
        post :create, user: user_attributes
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include("Hi #{user_attributes[:full_name].html_safe}")
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

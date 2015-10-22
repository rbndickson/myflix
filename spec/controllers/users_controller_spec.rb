require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns @user" do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "when the input is valid" do
      before { post :create, user: Fabricate.attributes_for(:user) }

      it "creates a new user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in path" do
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context "when the input is invalid" do
      before { post :create, user: { password: "password" } }

      it "does not create a new user" do
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "assigns @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context "email sending" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends an email to a user with valid inputs" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries).to be_present
      end
      it "sends to the right recipient" do
        user_attributes = Fabricate.attributes_for(:user)
        post :create, user: user_attributes
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([user_attributes[:email]])
      end
      it "sends the correct content" do
        user_attributes = Fabricate.attributes_for(:user)
        post :create, user: user_attributes
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include("Hi #{user_attributes[:full_name]}")
      end

      it "does not send an email with invalid inputs" do
        post :create, user: { email: 'a@b.com' }
        expect(ActionMailer::Base.deliveries).to be_empty
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

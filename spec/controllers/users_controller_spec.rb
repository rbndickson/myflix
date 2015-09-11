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
  end
end

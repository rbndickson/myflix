require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      user = Fabricate(:user)
      get :show, id: user.token
      expect(response).to render_template(:show)
    end

    it "assigns @token" do
      user = Fabricate(:user)
      get :show, id: user.token
      expect(assigns(:token)).to eq(user.token)
    end

    it "redirects to the expired token page if the token has expired" do
      get :show, id: '12345'
      expect(response).to redirect_to(expired_token_path)
    end
  end

  describe "POST create" do
    context "with valid token" do
      let(:user) { Fabricate(:user) }

      it "redirects to the sign in page" do
        post :create, token: user.token, password: 'new_password'
        expect(response).to redirect_to(sign_in_path)
      end

      it "updates the user's password" do
        post :create, token: user.token, password: 'new_password'
        expect(user.reload.authenticate('new_password')).to be_truthy
      end

      it "sets the flash success message" do
        post :create, token: user.token, password: 'new_password'
        expect(flash[:success]).to be_present
      end

      it "regenerates the token" do
        token = user.token
        post :create, token: user.token, password: 'new_password'
        expect(user.reload.token).not_to eq(token)
      end
    end

    context "with invalid token" do
      it "redirects to the expired token page" do
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to(expired_token_path)
      end
    end
  end
end

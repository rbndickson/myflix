require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    context "with unauthenticated users" do
      it "renders the new user template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "with authenticated users" do
      it "redirects to the home path" do
        session[:user_id] = Fabricate(:user).id
        get :new
        expect(response).to redirect_to(home_path)
      end
    end
  end

  describe "POST create" do
    let (:alice) { Fabricate(:user) }

    context "with valid email and password" do
      before do
        post :create, email: alice.email, password: alice.password
      end

      it "saves the users id to the session" do
        expect(session[:user_id]).to eq(alice.id)
      end

      it "redirects to the home path" do
        expect(response).to redirect_to(home_path)
      end

      it "sets the flash notice" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid email or password" do
      before do
        post :create, email: alice.email, password: alice.password + 'aaa'
      end

      it "does not put the user in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "redirects to the sign in path" do
        expect(response).to redirect_to(sign_in_path)
      end

      it "sets a flash notice" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:id] = Fabricate(:user).id
      get :destroy
    end

    it "clears the session for the user" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root path" do
      expect(response).to redirect_to(root_path)
    end

    it "sets a flash notice" do
      expect(flash[:info]).not_to be_blank
    end
  end
end

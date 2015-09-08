require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template(:new)
    end

    it "redirects to the home path if user is signed in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to(home_path)
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      let (:alice) { Fabricate(:user) }

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

    context "with invalid credentials" do
      it "does not puts the user in the session" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password + 'aaa'
        expect(session[:user_id]).to be_nil
      end

      it "redirects to the sign in path if details incorrect" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password + 'aaa'
        expect(response).to redirect_to(sign_in_path)
      end

      it "sets the flash notice" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password + 'aaa'
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

    it "sets the flash notice" do
      expect(flash[:info]).not_to be_blank
    end
  end
end

require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "users must be signed in" do
      let(:action) { get :new }
    end

    it "assigns @video to a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end

    it "redirects a regular user to the home path" do
      set_current_user
      get :new
      expect(response).to redirect_to(home_path)

    end
    it "sets a flash error message for a regular user" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end
end

require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "assigns @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "assigns @reviews for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      # matches against the array regardless of order
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it "redirects to sign in page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to (sign_in_path)
    end
  end

  describe "GET search" do
    let (:video) { Fabricate(:video) }

    context "with authenticated users" do
      before do
        session[:user_id] = Fabricate(:user).id
        get :search, query: video.title
      end

      it "assigns @search_term" do
        expect(assigns(:query)).to eq(video.title)
      end

      it "assigns @results" do
        expect(assigns(:results)).to eq([video])
      end
    end

    it "redirects to the sign in page for unauthenticated users" do
      get :search, query: video.title
      expect(response).to redirect_to(sign_in_path)
    end
  end
end

require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated users" do
      it "assigns @video" do
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "assigns @reviews" do
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end

    context "with unauthenticated users" do
      it "redirects to sign in page" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to (sign_in_path)
      end
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

    context "with unauthenticated users" do
      it "redirects to the sign in page" do
        get :search, query: video.title
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end

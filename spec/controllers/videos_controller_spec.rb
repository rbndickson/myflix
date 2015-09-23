require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:video) { Fabricate(:video) }

    it_behaves_like "users must be signed in" do
      let(:action) { get :show, id: video.id }
    end

    context "with authenticated users" do
      before { set_current_user }

      it "assigns @video" do
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "assigns @reviews" do
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end
  end

  describe "GET search" do
    let (:video) { Fabricate(:video) }

    it_behaves_like "users must be signed in" do
      let(:action) { get :search, query: video.title }
    end

    context "with authenticated users" do
      before do
        set_current_user
        get :search, query: video.title
      end

      it "assigns @search_term" do
        expect(assigns(:query)).to eq(video.title)
      end

      it "assigns @results" do
        expect(assigns(:results)).to eq([video])
      end
    end
  end
end

require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video)  { Fabricate(:video) }

    context "with authenticated user" do
      let(:current_user) { Fabricate(:user) }

      before { session[:user_id] = current_user.id }

      context "inputs are valid" do
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end

        it "saves the review to the database" do
          expect(Review.count).to eq(1)
        end

        it "redirects to the video show page" do
          expect(response).to redirect_to(video)
        end

        it "creates a review asscociated with the video reviewed" do
          expect(Review.first.video).to eq(video)
        end

        it "creates a review asscociated with the signed in user" do
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "one or more inputs are invalid" do
        it "does not save the review to the database" do
          post :create, review: { rating: 3 }, video_id: video.id
          expect(Review.count).to eq(0)
        end

        it "renders the video page" do
          post :create, review: { rating: 3 }, video_id: video.id
          expect(response).to render_template 'videos/show'
        end
        # to render the video page you need these instance variables:
        it "assigns @video" do
          post :create, review: { rating: 3 }, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it "assigns @reviews" do
          review1 = Fabricate(:review, video: video)
          review2 = Fabricate(:review, video: video)
          post :create, review: { rating: 3 }, video_id: video.id
          expect(assigns(:reviews)).to match_array([review1, review2])
        end
      end
    end

    context "with unauthenticated user" do
      it "redirects to the sign in path" do
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end

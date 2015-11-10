require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "users must be signed in" do
      let(:action) { get :new }
    end

    it_behaves_like "admin is required" do
      let(:action) { get :new }
    end

    it "assigns @video to a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end

    it "sets a flash error message for a regular user" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "users must be signed in" do
      let(:action) { post :create }
    end

    it_behaves_like "admin is required" do
      let(:action) { get :new }
    end

    context "with valid input" do
      let(:comedy) { Fabricate(:category) }

      before do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video, category_id: comedy.id)
      end

      it "redirects to the add new video page" do
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a new video" do
        expect(Video.count).to eq(1)
      end

      it "sets a confirmation message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      let(:comedy) { Fabricate(:category) }

      before do
        set_current_admin
        post :create, video: { category_id: comedy.id, description: "Funny!" }
      end

      it "does not create a video" do
        expect(Video.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "assigns @video" do
        expect(assigns(:video)).to be_instance_of(Video)
      end

      it "sets an error message" do
        expect(flash[:danger]).to be_present
      end
    end
  end
end

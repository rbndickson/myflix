require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it "assigns @queue_items to the queue items of the current user" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item1 = Fabricate(:queue_item, video_id: 1, user: alice )
      queue_item2 = Fabricate(:queue_item, video_id: 2, user: alice )
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to the login page for unauthenticated users" do
      get :index
      expect(response).to redirect_to(sign_in_path)
    end
  end

  describe 'POST create' do
    context "user is authenticated" do
      let(:alice) { Fabricate(:user) }
      let(:superman) { Fabricate(:video) }
      before { session[:user_id] = alice.id }

      it "redirects to the my queue page" do
        post :create, video_id: superman.id
        expect(response).to redirect_to(my_queue_path)
      end

      it "saves a new queue item" do
        post :create, video_id: superman.id
        expect(QueueItem.count).to eq(1)
      end

      it "saves a queue item assiciated with the video" do
        post :create, video_id: superman.id
        expect(QueueItem.first.video).to eq(superman)
      end

      it "saves a queue item associatied with the signed in user" do
        post :create, video_id: superman.id
        expect(QueueItem.first.user).to eq(alice)
      end

      it "sets the list order position" do
        batman = Fabricate(:video)
        spiderman = Fabricate(:video)
        Fabricate(:queue_item, video_id: batman.id, user_id: alice.id, position: 1)
        post :create, video_id: spiderman.id
        spiderman_queue_item = QueueItem.where(video_id: spiderman.id, user_id: alice.id).first
        expect(spiderman_queue_item.position).to eq(2)
      end

      it "does not add the same video twice" do
        Fabricate(:queue_item, video_id: superman.id, user_id: alice.id)
        post :create, video_id: superman.id

        expect(QueueItem.count).to eq(1)
      end
    end

    context "user is not authenticated" do
      it "redirects to the sign in page if user is not authenticated" do
        post :create, video_id: 3
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end

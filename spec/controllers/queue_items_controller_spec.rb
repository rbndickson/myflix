require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do

    it_behaves_like "users must be signed in" do
      let(:action) { get :index }
    end

    it "assigns @queue_items to the current user's queue items" do
      set_current_user
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: current_user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item])
    end
  end

  describe 'POST create' do
    before { set_current_user }

    let(:video) { Fabricate(:video) }

    it_behaves_like "users must be signed in" do
      let(:action) { post :create, video_id: video.id }
    end

    it "redirects to the my queue page" do
      post :create, video_id: video.id
      expect(response).to redirect_to(my_queue_path)
    end

    it "saves a new queue item" do
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "saves a queue item associated with the video" do
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "saves a queue item associatied with the signed in user" do
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(current_user)
    end

    it "sets the list order position" do
      Fabricate(:queue_item, video: video, user: current_user, position: 1)
      video2 = Fabricate(:video)
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.find_by(video: video2, user: current_user)
      expect(video2_queue_item.position).to eq(2)
    end

    it "does not add the same video twice" do
      Fabricate(:queue_item, video: video, user: current_user)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
  end

  describe 'DELETE destroy' do
    let(:video) { Fabricate(:video) }
    let(:bob) { Fabricate(:user) }
    let(:queue_item) { Fabricate(:queue_item, video: video, user: current_user, position: 1) }
    let(:bobs_queue_item) { Fabricate(:queue_item, video: video, user: bob, position: 1) }

    before { set_current_user }

    it_behaves_like "users must be signed in" do
      let(:action) { delete :destroy, id: bobs_queue_item.id }
    end

    it "redirects to the my queue page" do
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to(my_queue_path)
    end

    it "deletes queue item" do
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes the remaining queue items" do
      video2 = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, video: video, user: current_user, position: 1)
      queue_item2 = Fabricate(:queue_item, video: video2, user: current_user, position: 2)
      delete :destroy, id: queue_item1.id
      expect(queue_item2.reload.position).to eq(1)
    end

    it "does not allow a user to delete a queue item that they do not own" do
      delete :destroy, id: bobs_queue_item.id
      expect(QueueItem.all).to eq([bobs_queue_item])
    end
  end

  describe "POST update_queue" do
    context "with valid inputs by an authenticated user" do
      let(:video1) { Fabricate(:video) }
      let(:video2) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, video: video1, user: current_user, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, video: video2, user: current_user, position: 2) }

      before do
        set_current_user
        post :update_queue, queue_items: [
          { id: queue_item1.id, position: 3 },
          { id: queue_item2.id, position: 2 }
        ]
      end

      it "redirects to the my queue page" do
        expect(response).to redirect_to(my_queue_path)
      end

      it "reorders the queue items" do
        expect(current_user.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    context "with invalid inputs by authenticated user" do
      let(:video1) { Fabricate(:video) }
      let(:video2) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, video: video1, user: current_user, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, video: video2, user: current_user, position: 2) }

      before do
        set_current_user
        post :update_queue, queue_items: [
          { id: queue_item1.id, position: 2 },
          { id: queue_item2.id, position: 1.5 }
        ]
      end

      it "directs to the my queue page" do
        expect(response).to redirect_to(my_queue_path)
      end

      it "sets the flash error message" do
        expect(flash[:warning]).to be_present
      end

      it "does not change any queue items even if some positions are valid" do
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated user" do
      it "redirects to the sign in path" do
        alice = Fabricate(:user)
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, video: video, user: alice)
        post :update_queue, queue_items: [{ id: queue_item.id, position: 1 }]
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context "when queue items do not belong to the current user" do
      it "does not change the queue items" do
        set_current_user
        alice = current_user
        bob = Fabricate(:user)
        video1 = Fabricate(:video)
        queue_item_alice = Fabricate(:queue_item, video: video1, user: alice, position: 1)
        queue_item_bob = Fabricate(:queue_item, video: video1, user: bob, position: 2)
        post :update_queue, queue_items: [
          { id: queue_item_alice.id, position: 2 },
          { id: queue_item_bob.id, position: 1 }
        ]
        expect(queue_item_bob.reload.position).to eq(2)
      end
    end
  end
end

require 'spec_helper'

describe QueueItemsController do
  let(:alice) { Fabricate(:user, id: 1) }
  let(:superman) { Fabricate(:video, title: "Superman") }
  let(:batman) { Fabricate(:video, title: "Batman") }

  describe 'GET index' do
    it "assigns @queue_items to the queue items of the current user" do
      session[:user_id] = alice.id
      superman_queue_item = Fabricate(:queue_item, video: superman, user: alice)
      batman_queue_item = Fabricate(:queue_item, video: batman, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([superman_queue_item, batman_queue_item])
    end

    it "redirects to the login page for unauthenticated users" do
      get :index
      expect(response).to redirect_to(sign_in_path)
    end
  end

  describe 'POST create' do
    context "user is authenticated" do
      before { session[:user_id] = alice.id }

      it "redirects to the my queue page" do
        post :create, video_id: superman.id
        expect(response).to redirect_to(my_queue_path)
      end

      it "saves a new queue item" do
        post :create, video_id: superman.id
        expect(QueueItem.count).to eq(1)
      end

      it "saves a queue item associated with the video" do
        post :create, video_id: superman.id
        expect(QueueItem.first.video).to eq(superman)
      end

      it "saves a queue item associatied with the signed in user" do
        post :create, video_id: superman.id
        expect(QueueItem.first.user).to eq(alice)
      end

      it "sets the list order position" do
        Fabricate(:queue_item, video: superman, user: alice, position: 1)
        post :create, video_id: batman.id
        batman_queue_item = QueueItem.where(video: batman, user: alice).first
        expect(batman_queue_item.position).to eq(2)
      end

      it "does not add the same video twice" do
        Fabricate(:queue_item, video: superman, user: alice)
        post :create, video_id: superman.id
        expect(QueueItem.count).to eq(1)
      end
    end

    context "user is not authenticated" do
      it "redirects to the sign in page if user is not authenticated" do
        post :create, video_id: superman.id
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe 'DELETE destroy' do
      let(:queue_item) { Fabricate(:queue_item, video: superman, user: alice, position: 1) }

      it "redirects to the my queue page" do
        session[:user_id] = alice.id
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to(my_queue_path)
      end

      it "deletes queue item" do
        session[:user_id] = alice.id
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "does not allow a user to delete a queue item that they do not own" do
        bryan = Fabricate(:user, id: 2)
        session[:user_id] = bryan.id
        delete :destroy, id: queue_item.id
        expect(QueueItem.all).to eq([queue_item])
      end

      it "redirect to the sign in page for unauthenticated users" do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end

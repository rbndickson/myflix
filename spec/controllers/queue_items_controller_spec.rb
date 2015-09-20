require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    context "when user is authenticated" do
      it "assigns @queue_items to the current user's queue items" do
        alice = Fabricate(:user)
        video = Fabricate(:video)
        session[:user_id] = alice.id
        queue_item = Fabricate(:queue_item, video: video, user: alice)
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item])
      end
    end

    context "when user is unauthenticated" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end

  describe 'POST create' do
    let(:alice) { Fabricate(:user) }
    let(:superman) { Fabricate(:video) }

    context "when user is authenticated" do
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
        batman = Fabricate(:video)
        post :create, video_id: batman.id
        batman_queue_item = QueueItem.find_by(video: batman, user: alice)
        expect(batman_queue_item.position).to eq(2)
      end

      it "does not add the same video twice" do
        Fabricate(:queue_item, video: superman, user: alice)
        post :create, video_id: superman.id
        expect(QueueItem.count).to eq(1)
      end
    end

    context "when user is unauthenticated" do
      it "redirects to the sign in page" do
        post :create, video_id: superman.id
        expect(response).to redirect_to(sign_in_path)
      end
    end

    describe 'DELETE destroy' do
      context "when user is authenticated" do
        let(:alice) { Fabricate(:user) }
        let(:superman) { Fabricate(:video) }
        let(:queue_item) { Fabricate(:queue_item, video: superman, user: alice, position: 1) }

        before { session[:user_id] = alice.id }

        it "redirects to the my queue page" do
          delete :destroy, id: queue_item.id
          expect(response).to redirect_to(my_queue_path)
        end

        it "deletes queue item" do
          delete :destroy, id: queue_item.id
          expect(QueueItem.count).to eq(0)
        end

        it "normalizes the remaining queue items" do
          batman = Fabricate(:video)
          spiderman = Fabricate(:video)
          queue_item1 = Fabricate(:queue_item, video: superman, user: alice, position: 1)
          queue_item2 = Fabricate(:queue_item, video: batman, user: alice, position: 2)
          queue_item3 = Fabricate(:queue_item, video: spiderman, user: alice, position: 3)
          delete :destroy, id: queue_item2.id
          expect(queue_item1.reload.position).to eq(1)
          expect(queue_item3.reload.position).to eq(2)
        end

        it "does not allow a user to delete a queue item that they do not own" do
          bob = Fabricate(:user)
          bobs_queue_item = Fabricate(:queue_item, video: superman, user: bob, position: 1)
          delete :destroy, id: bobs_queue_item.id
          expect(QueueItem.all).to eq([bobs_queue_item])
        end
      end

      context "when user is unauthenticated" do
        it "redirect to the sign in page" do
          alice = Fabricate(:user)
          video = Fabricate(:video)
          queue_item = Fabricate(:queue_item, video: video, user: alice)
          delete :destroy, id: queue_item.id
          expect(response).to redirect_to(sign_in_path)
        end
      end
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      let(:alice) { Fabricate(:user) }
      let(:superman) { Fabricate(:video) }
      let(:batman) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, video: superman, user: alice, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, video: batman, user: alice, position: 2) }

      before do
        session[:user_id] = alice.id
        post :update_queue, queue_items: [
          { id: queue_item1.id, position: 3 },
          { id: queue_item2.id, position: 2 }
        ]
      end

      it "redirects to the my queue page" do
        expect(response).to redirect_to(my_queue_path)
      end

      it "reorders the queue items" do
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    context "with invalid inputs" do
      let(:alice) { Fabricate(:user) }
      let(:superman) { Fabricate(:video) }
      let(:batman) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, video: superman, user: alice, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, video: batman, user: alice, position: 2) }

      before do
        session[:user_id] = alice.id
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

    context "when user is unauthenticated" do
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
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        bob = Fabricate(:user)
        superman = Fabricate(:video)
        queue_item_alice = Fabricate(:queue_item, video: superman, user: alice, position: 1)
        queue_item_bob = Fabricate(:queue_item, video: superman, user: bob, position: 2)
        post :update_queue, queue_items: [
          { id: queue_item_alice.id, position: 2 },
          { id: queue_item_bob.id, position: 1 }
        ]
        expect(queue_item_bob.reload.position).to eq(2)
      end
    end
  end
end

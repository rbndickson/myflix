require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    let(:alice) { Fabricate(:user) }

    it_behaves_like "users must be signed in" do
      let(:action) { get :index }
    end

    it "assigns @user" do
      set_current_user(alice)
      get :index
      expect(assigns(:user)).to eq(alice)
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }

    it_behaves_like "users must be signed in" do
      let(:action) { post :create, id: alice.id }
    end

    context "when the relationship is not a duplicate" do
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate(:user) }

      before do
        set_current_user(alice)
        post :create, id: bob.id
      end

      it "creates a new Relationship record" do
        expect(Relationship.count).to eq(1)
      end

      it "create a single leading relationship" do
        expect(alice.leaders).to eq([bob])
        expect(bob.leaders).to be_empty
      end

      it "creates a single following relationship" do
        expect(bob.followers).to eq([alice])
        expect(alice.followers).to be_empty
      end

      it "sets a success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "when the relationship is a duplicate" do
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate(:user) }

      before do
        set_current_user(alice)
        alice.follow(bob)
        post :create, id: bob.id
      end

      it "does not create a duplicate record" do
        expect(Relationship.count).to eq(1)
      end

      it "sets an error message" do
        expect(flash[:danger]).to be_present
      end

      it "reloads the page" do
        expect(response).to redirect_to(user_path(bob))
      end
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    it_behaves_like "users must be signed in" do
      let(:action) do
        alice.follow(bob)
        delete :destroy, id: bob.id
      end
    end

    before do
      set_current_user(alice)
      alice.follow(bob)
      delete :destroy, id: bob.id
    end

    it "deletes the record" do
      expect(Relationship.count).to eq(0)
    end

    it "displays a confirmation message" do
      expect(flash[:info]).to be_present
    end

    it "redirects to the people page" do
      expect(response).to redirect_to(people_path)
    end
  end
end

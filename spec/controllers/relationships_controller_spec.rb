require 'spec_helper'

describe RelationshipsController do
  let(:alice) { Fabricate(:user) }

  describe "GET index" do
    it "assigns @user" do
      set_current_user(alice)
      get :index
      expect(assigns(:user)).to eq(alice)
    end
  end

  describe "POST create" do
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
end

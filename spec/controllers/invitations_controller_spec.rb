require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "users must be signed in" do
      let(:action) { get :new }
    end

    it "assigns @invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end
  end

  describe "POST create" do
    it_behaves_like "users must be signed in" do
      let(:action) { get :create }
    end

    context "with valid inputs" do
      before do
        set_current_user
        post :create, invitation: { recipient_email: 'bob@example.com', recipient_name: 'Bob', message: 'Hi :) check out this website!' }
      end

      it "redirects to the invitations page" do
        expect(response).to redirect_to(new_invitation_path)
      end

      it "creates an invitation" do
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@example.com'])
      end

      it "sets a success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      after { ActionMailer::Base.deliveries.clear }

      before do
        set_current_user
        post :create, invitation: { recipient_email: 'oops' }
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets an error message" do
        expect(flash[:danger]).to be_present
      end

      it "assigns @invitation" do
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end

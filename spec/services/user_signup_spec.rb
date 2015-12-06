require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "with valid personal info and valid card" do
      let(:alice) { Fabricate(:user) }
      let(:customer) { double(:customer, successful?: true, customer_token: "abcdefg") }
      let(:sign_up_joe) { UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', full_name: 'Joe Doe')).sign_up("stripe_token", nil) }
      let(:invitation) { Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com') }
      let(:sign_up_joe_with_invitation) { UserSignup.new(Fabricate.build(:user, email:'joe@example.com', password: 'password', full_name: 'Joe Doe')).sign_up("stripe_token", invitation.token) }

      before { expect(StripeWrapper::Customer).to receive(:create).and_return(customer) }
      after { ActionMailer::Base.deliveries.clear }

      it "creates a new user" do
        sign_up_joe
        expect(User.count).to eq(1)
      end

      it "sends an email to a user with valid inputs" do
        sign_up_joe
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sends the correct content" do
        sign_up_joe
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include("Hi Joe Doe")
      end

      it "stores the customer token from Stripe" do
        sign_up_joe
        expect(User.first.customer_token).to eq("abcdefg")
      end

      it "makes the user follow the inviter" do
        sign_up_joe_with_invitation
        joe = User.find_by(email: 'joe@example.com')
        expect(joe.follows?(alice)).to be_truthy
      end

      it "makes the inviter follow the user" do
        sign_up_joe_with_invitation
        joe = User.find_by(email: 'joe@example.com')
        expect(alice.follows?(joe)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        sign_up_joe_with_invitation
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with valid personal info but declined card" do
      it "does not create a new user record" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined.")
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      let(:sign_up_with_invalid_info) { UserSignup.new(User.new(email: "invalid")).sign_up("stripe_token", nil) }

      it "does not create a new user" do
        sign_up_with_invalid_info
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:create)
        sign_up_with_invalid_info
      end

      it "does not send an email" do
        ActionMailer::Base.deliveries.clear
        sign_up_with_invalid_info
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end

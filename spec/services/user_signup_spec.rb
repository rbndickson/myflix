require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "with valid personal info and valid card" do
      let(:alice) { Fabricate(:user) }
      let(:charge) { double(:charge, successful?: true) }

      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }
      after { ActionMailer::Base.deliveries.clear }

      it "creates a new user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "sends an email to a user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com')).sign_up("stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sends the correct content" do
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', full_name: 'Joe Doe')).sign_up("stripe_token", nil)
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include("Hi Joe Doe")
      end

      it "makes the user follow the inviter" do
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email:'joe@example.com', password: 'password', full_name: 'Joe Doe')).sign_up("stripe_token", invitation.token)
        joe = User.find_by(email: 'joe@example.com')
        expect(joe.follows?(alice)).to be_truthy
      end

      it "makes the inviter follow the user" do
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email:'joe@example.com', password: 'password', full_name: 'Joe Doe')).sign_up("stripe_token", invitation.token)
        joe = User.find_by(email: 'joe@example.com')
        expect(alice.follows?(joe)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email:'joe@example.com', password: 'password', full_name: 'Joe Doe')).sign_up("stripe_token", invitation.token)
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with valid personal info but declined card" do
      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      it "does not create a new user" do
        UserSignup.new(User.new(email: "new@example.com")).sign_up("stripe_token", nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        UserSignup.new(User.new(email: "new@example.com")).sign_up("stripe_token", nil)
      end

      it "does not send an email" do
        ActionMailer::Base.deliveries.clear
        UserSignup.new(User.new(email: "new@example.com")).sign_up("stripe_token", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end

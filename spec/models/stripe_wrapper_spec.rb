require 'spec_helper'

describe StripeWrapper do
  let(:alice) { Fabricate(:user) }
  let(:valid_token) { create_stripe_token("4242424242424242").id }
  let(:declined_token) { create_stripe_token("4000000000000002").id }

  describe StripeWrapper::Charge do
    describe '.create' do
      it "makes a successful charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: valid_token,
          description: "Valid example charge for valid@example.com"
        )
        expect(response).to be_successful
      end

      it "makes a card declined charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: declined_token,
          description: "Invalid example charge for invalid@example.com"
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: declined_token,
          description: "Invalid example charge"
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer with a valid card", :vcr do
        response = StripeWrapper::Customer.create(
          user: alice,
          source: valid_token
        )
        expect(response).to be_successful
      end

      it "does not create a customer with a declined card", :vcr do
        response = StripeWrapper::Customer.create(
          user: alice,
          source: declined_token
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for declined card", :vcr do
        response = StripeWrapper::Customer.create(
          user: alice,
          source: declined_token
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end

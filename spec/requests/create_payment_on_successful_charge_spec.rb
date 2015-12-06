require 'spec_helper'

describe "create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_17DYDzF0WzU2IQJErRtelDjH",
      "object" => "event",
      "api_version" => "2015-10-16",
      "created" => 1449053559,
      "data" => {
        "object" => {
          "id" => "ch_17DYDzF0WzU2IQJEsrklMa3C",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => "txn_17DYDzF0WzU2IQJEPwIbXnho",
          "captured" => true,
          "created" => 1449053559,
          "currency" => "usd",
          "customer" => "cus_7STAlPqqgr3Vv7",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {},
          "invoice" => "in_17DYDzF0WzU2IQJEr9FmhaBG",
          "livemode" => false,
          "metadata" => {},
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_17DYDzF0WzU2IQJEsrklMa3C/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_17DYDxF0WzU2IQJEyAMDvBW6",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_7STAlPqqgr3Vv7",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 12,
            "exp_year" => 2016,
            "fingerprint" => "RW2p59TP9xAwhTjZ",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "statement_descriptor" => nil,
          "status" => "succeeded"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_7STAhIyMfCv5IS",
      "type" => "charge.succeeded"
    }
  end

  it "creates a payment with the stripe webhook when the charge succeeds", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_7STAlPqqgr3Vv7")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    Fabricate(:user, customer_token: "cus_7STAlPqqgr3Vv7")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    Fabricate(:user, customer_token: "cus_7STAlPqqgr3Vv7")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_17DYDzF0WzU2IQJEsrklMa3C")
  end
end

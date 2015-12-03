require 'spec_helper'

describe "deactivate user on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_17DxuZF0WzU2IQJEAnssKbSd",
      "object" => "event",
      "api_version" => "2015-10-16",
      "created" => 1449152299,
      "data" => {
        "object" => {
          "id" => "ch_17DxuZF0WzU2IQJEP1sOHyEe",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1449152299,
          "currency" => "usd",
          "customer" => "cus_7SdQEO18XlhRbM",
          "description" => "payment to fail",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {},
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {},
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_17DxuZF0WzU2IQJEP1sOHyEe/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_17DxssF0WzU2IQJE91j6sAVF",
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
            "customer" => "cus_7SdQEO18XlhRbM",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 12,
            "exp_year" => 2017,
            "fingerprint" => "mnOdkQ2R5kdZCGG0",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "statement_descriptor" => nil,
          "status" => "failed"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_7SthHBS3UxwOt9",
      "type" => "charge.failed"
    }
  end

  it "deactivates the user with the stripe webhook when the charge fails",  :vcr do
    alice = Fabricate(:user, customer_token: "cus_7SdQEO18XlhRbM")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end

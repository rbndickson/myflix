require 'spec_helper'

describe ForgotPasswordController do
  describe 'POST create' do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to(forgot_password_path)
      end

      it "sets an error message" do
        post :create, email: ''
        expect(flash[:danger]).to be_present
      end
    end

    context "with known email" do
      after { ActionMailer::Base.deliveries.clear }

      it "redirects to the confirmation page" do
        user = Fabricate(:user)
        post :create, email: user.email
        expect(response).to redirect_to(forgot_password_confirmation_path)
      end

      it "sends a mail to the email address" do
        user = Fabricate(:user)
        post :create, email: user.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end
    end

    context "with unknown email" do
      it "redirects to the forgot password page" do
        post :create, email: 'a@b.com'
        expect(response).to redirect_to(forgot_password_path)
      end

      it "sets an error message" do
        post :create, email: 'a@b.com'
        expect(flash[:danger]).to be_present
      end
    end
  end
end

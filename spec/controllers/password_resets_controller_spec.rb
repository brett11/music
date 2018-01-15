require 'rails_helper'
require 'pry'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe "GET new" do
    it "does work" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    it "does not allow without valid email" do
      post :create, params: { password_reset: { email: "not_gonna_work" } }
      expect(assigns(:user)).to_not be_present
      expect(response).to render_template(:new)
      expect(flash[:danger]).to eq("Email address not found")
    end

    it "redirects to root_url upon successful password_reset creation and shows flash" do
      post :create, params: { password_reset: { email: user.email } }
      expect(assigns(:user)).to be_present
      expect(response).to redirect_to(:root)
      expect(flash[:info]).to eq("Email sent with password reset instructions")
    end
  end

  describe "GET edit" do
    it "works" do
      user.create_reset_digest
      get :edit, params: {id: user.reset_token, email: user.email }
      expect(assigns(:user)).to be_present
    end
  end

  describe "POST update" do
    describe "without a password" do
      it "does not allow" do
        user.create_reset_digest
        post :update, params: {id: user.reset_token, email: user.email, user: {password: "", password_confirmation: ""}}
        expect(response).to render_template(:edit)
      end
    end

    describe "with valid password" do
      it "does allow" do
        user.create_reset_digest
        post :update, params: {id: user.reset_token, email: user.email, user: { password: "foobaryeah", password_confirmation: "foobaryeah"}}
        expect(response).to redirect_to(user_path(user))
        expect(flash[:success]).to eq("Password has been reset.")
      end
    end
  end
end
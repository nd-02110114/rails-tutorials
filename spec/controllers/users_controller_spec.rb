require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "check sign up redirect" do
    it "not success post redirect" do
      params = {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }

      post :create, params: params
      assert_template 'users/new'
    end

    it "success post redirect" do
      params = {
        user: {
          name: "Example User",
          email: "user@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }

      post :create, params: params
      assert_redirected_to user_path(assigns(:user))
      expect(flash[:success]).not_to be_empty
    end
  end
end

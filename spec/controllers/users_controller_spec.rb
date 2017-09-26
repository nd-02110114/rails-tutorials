require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "should get right action" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "should redirect index when not logged in" do
      get :index
      assert_redirected_to login_path
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

    it "check success post redirect & flash message should appear" do
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
      assert is_logged_in?
      expect(flash[:success]).not_to be_empty
    end
  end

end

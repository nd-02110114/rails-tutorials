require 'rails_helper'

RSpec.describe "Users Sign Up Test", type: :request do

  describe "Users Invalid Sign Up" do
    before do
      visit signup_path
      fill_in "Name",         with: ""
      fill_in "Email",        with: "user@invalid"
      fill_in "Password",     with: "foo"
      fill_in "Confirmation", with: "bar"
    end

    it "invalid signup information" do
      expect { click_button "Create my account" }.not_to change(User, :count)
    end

    it "error message should appear" do
        click_button "Create my account"
        expect(page).to have_selector("#error_explanation")
        expect(page).to have_selector(".field_with_errors")
    end
  end

  describe "Users Valid Sign Up" do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it "valid signup information" do
      visit signup_path
      fill_in "Name",         with: "Example User"
      fill_in "Email",        with: "user@example.com"
      fill_in "Password",     with: "password"
      fill_in "Confirmation", with: "password"
      expect { click_button "Create my account" }.to change(User, :count).by(1)
    end

    it "valid signup information with account activation" do
      get signup_path
      post users_path, params: { user: { name:  "Example User",
                                       email: "user@example.com",
                                       password:              "password",
                                       password_confirmation: "password" } }
      assert_equal 1, ActionMailer::Base.deliveries.size
      user = assigns(:user)
      assert_equal false, user.activated?
      # activateされてない時にprofile画面にアクセスしてみる
      get user_path(user)
      assert_redirected_to root_path
      # 有効化していない状態でログインしてみる
      log_in_with_post(user)
      assert_equal false, is_logged_in?
      # 有効化トークンが不正な場合
      get edit_account_activation_url("invalid token", email: 'wrong')
      assert_equal false, is_logged_in?
      # トークンは正しいがメールアドレスが無効な場合
      get edit_account_activation_url(user.activation_token,email: '')
      assert_equal false, is_logged_in?
      
      # 有効化トークンが正しい場合
      get edit_account_activation_url(user.activation_token, email: user.email)
      assert user.reload.activated?
      follow_redirect!
      assert_template 'users/show'
      assert is_logged_in?
    end
  end

end

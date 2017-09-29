require 'rails_helper'

RSpec.describe "Users Password Reset Test", type: :request do
  before do
    ActionMailer::Base.deliveries.clear
    @user = FactoryGirl.create(:user)
  end

  it "password resets" do
    get new_password_reset_url
    assert_template 'password_resets/new'
     # メールアドレスが無効
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_equal false, flash.empty?
    assert_template 'password_resets/new'
    # メールアドレスが有効
    post password_resets_path, params: { password_reset: { email: @user.email } }
    expect(@user.reset_digest).not_to eq(@user.reload.reset_digest)
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal false, flash.empty?
    assert_redirected_to root_url
    # パスワード再設定フォームのテスト
    user = assigns(:user)
    # メールアドレスが無効
    get edit_password_reset_url(user.reset_token, email: "")
    assert_redirected_to root_url
    # メールアドレスが有効で、トークンが無効
    get edit_password_reset_url('Wrong token', email: user.email)
    assert_redirected_to root_url
    # メールアドレスもトークンも有効
    get edit_password_reset_url(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # 無効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
              params: { email: user.email,
                         user: { password:              "foobaz",
                                 password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
     # パスワードが空
    patch password_reset_path(user.reset_token),
              params: { email: user.email,
                         user: { password:              "",
                                password_confirmation:  "" } }
    assert_select 'div#error_explanation'
    # 有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
              params: { email: user.email,
                         user: { password:              "foobaz",
                                 password_confirmation: "foobaz" } }
    assert_nil user.reload.reset_digest
    assert is_logged_in?
    assert_equal false, flash.empty?
    assert_redirected_to user
  end

  it "expired token" do
    get new_password_reset_url
    post password_resets_path, params: { password_reset: { email: @user.email } }
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
              params: { email: @user.email,
                         user: { password:              "foobaz",
                                 password_confirmation: "foobaz" } }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end

end

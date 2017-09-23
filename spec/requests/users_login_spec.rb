require 'rails_helper'

RSpec.describe "Users Login Test", type: :request do
  before do
    @pass = "password"
    @user = FactoryGirl.create(:user, password: @pass,
                        password_confirmation: @pass)
  end

  it "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" }}
    assert_template 'sessions/new'
    assert flash.present?
    get root_path
    assert flash.empty?
  end

  it "proper login logout" do
    #login
    get login_path
    post login_path, params: { session: { email: @user.email, password: @pass} }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    #logout
    delete logout_path
    expect(is_logged_in?).to be_falsey
    assert_redirected_to root_url

    # 2つめのウィンドウでログアウトするシュミレート
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  it "login with remembering" do
    log_in_with_post(@user, remember_me:"1")
    assert cookies['remember_token'].present?
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  it "login without remembering" do
    # 最初はcookieを保存して、ログイン
    log_in_with_post(@user, remember_me:"1")
    delete logout_path

    # cookiesを削除して、ログイン
    log_in_with_post(@user, remember_me:"0")
    assert cookies['remember_token'].blank?
  end

end

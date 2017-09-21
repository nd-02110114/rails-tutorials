require 'rails_helper'

RSpec.describe "Users Login Test", type: :request do

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
    # 必要な変数の定義
    pass = "password"
    user = FactoryGirl.create(:user, password: pass,
                        password_confirmation: pass)

    #login
    get login_path
    post login_path, params: { session: { email: user.email, password: pass} }
    assert is_logged_in?
    assert_redirected_to user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(user)

    #logout
    delete logout_path
    expect(is_logged_in?).to be_falsey
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(user), count: 0
  end

end

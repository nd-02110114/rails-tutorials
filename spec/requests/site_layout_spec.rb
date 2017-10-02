require 'rails_helper'

RSpec.describe "Home View Test", type: :request do
  before do
    @user = FactoryGirl.create(:user)
  end

  it "layout link check" do
    # 非ログイン
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path

    # ログイン
    log_in_with_post(@user)
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_select '#following', @user.following.count.to_s
    assert_select '#followers', @user.followers.count.to_s
    # assert_select "a[href=?]", signup_path
  end

  it "contact title check" do
    get contact_path
    assert_select "title", full_title("Contact")
  end

  it "signup title check" do
    get signup_path
    assert_select "title", full_title("Sign up")
  end
end

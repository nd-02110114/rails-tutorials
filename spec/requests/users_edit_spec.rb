require 'rails_helper'

RSpec.describe "Users Edit Test", type: :request do
  before do
    @user = FactoryGirl.create(:user)
    @other_user = FactoryGirl.create(:other_user)
  end

  it "unsuccessful edit" do
    log_in_with_post(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                              email: "foo@invalid",
                              password: "foo",
                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select ".alert", "The form contains 4 errors."
  end

  it "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal edit_user_url(@user), session[:forwarding_url]
    log_in_with_post(@user)
    assert_redirected_to edit_user_path(@user) || default

    # 再ログイン
    delete logout_path
    log_in_with_post(@user)
    assert_redirected_to user_path(@user)

    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                              email: email,
                              password: "",
                              password_confirmation: "" } }
    assert flash.present?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end


  it "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert flash.present?
    assert_redirected_to login_url
  end

  it "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                    email: @user.email } }
    assert flash.present?
    assert_redirected_to login_url
  end

  it "should redirect edit when logged in as wrong user" do
    log_in_with_post(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  it "should redirect update when logged in as wrong user" do
    log_in_with_post(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  it "should not allow the admin attribute to be edited via the web" do
    log_in_with_post(@other_user)
    assert_equal @other_user.admin?, false
    patch user_path(@other_user), params: {
                             user: { password: 'password',
                                     password_confirmation: 'password',
                                     admin: true } }
    assert_equal @other_user.reload.admin?, false
  end
end

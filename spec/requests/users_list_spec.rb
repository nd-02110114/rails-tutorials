require 'rails_helper'

RSpec.describe "Users List Test", type: :request do
  before do
    @user = FactoryGirl.create(:user)
    FactoryGirl.create_list(:user_for_pagination, 30)
  end

  it "index including pagination" do
    log_in_with_post(@user)
    get users_path
    assert_select "div.pagination", count: 2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  it "should redirect destroy when not logged in" do
    expect { delete user_path(@user) }.not_to change(User, :count)
    assert_redirected_to login_url
  end

  it "should redirect destroy when logged in as a non-admin" do
    log_in_with_post(@user)
    expect { delete user_path(@user) }.not_to change(User, :count)
    assert_redirected_to root_url
  end

  it "index as admin including pagination and delete links" do
    admin_user = FactoryGirl.create(:admin_user)
    log_in_with_post(admin_user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_users = User.paginate(page: 1)
    first_page_users.each do |user|
      assert user.activated
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == admin_user
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    expect { delete user_path(@user) }.to change(User, :count).by(-1)
  end

  it "index as non-admin" do
    log_in_with_post(@user)
    get users_path
    assert_select  'a', text: 'delete', count: 0
  end
  
end

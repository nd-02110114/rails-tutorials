require 'rails_helper'

RSpec.describe "Users Profile Test", type: :request do
  include ApplicationHelper
  fixtures :microposts, :relationships, :users

  before do
    @user = users(:michael)
    @micropost = microposts(:orange)
  end

  it "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_select '#following', @user.following.count.to_s
    assert_select '#followers', @user.followers.count.to_s
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  it "should redirect create when not logged in" do
    expect { post microposts_path, params: {
      micropost: { content: "Lorem ipsum" } } }.not_to change(Micropost, :count)
    assert_redirected_to login_path
  end

  it "should redirect destroy when not logged in" do
    expect { delete micropost_path(@micropost) }.not_to change(Micropost, :count)
    assert_redirected_to login_path
  end

  it "should redirect destroy for wrong micropost" do
    log_in_with_post(@user)
    micropost = microposts(:ants)
    expect { delete micropost_path(micropost) }.not_to change(Micropost, :count)
    assert_redirected_to root_url
  end

  it "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  it "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end

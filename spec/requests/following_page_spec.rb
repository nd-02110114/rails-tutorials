require 'rails_helper'

RSpec.describe "Following Test", type: :request do
  fixtures :users, :relationships

  before do
    @user = users(:michael)
    log_in_with_post(@user)
  end

  it "following page" do
    get following_user_path(@user)
    assert_equal false, @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
     assert_select "a[href=?]", user_path(user)
    end
  end

  it "followers page" do
    get followers_user_path(@user)
    assert_equal false, @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
     assert_select "a[href=?]", user_path(user)
    end
  end

  it "feed on Home page" do
    get root_path
    @user.feed.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end
end

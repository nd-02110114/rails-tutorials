require 'rails_helper'

RSpec.describe "Users List Pagination Test", type: :request do
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

end

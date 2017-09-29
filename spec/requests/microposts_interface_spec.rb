require 'rails_helper'

RSpec.describe "Micropost Interface Test", type: :request do
  fixtures :users

  before do
    @user = users(:michael)
  end

  it "micropost interface" do
    log_in_with_post(@user)
    get root_path
    assert_select 'div.pagination'
    # # 無効な送信
    # expect { post microposts_path, params: {
    #   micropost: { content: "" } } }.not_to change(Micropost, :count)
    # assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    expect { post microposts_path, params: {
      micropost: { content: content } } }.to change(Micropost, :count).by(1)
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    expect { delete micropost_path(first_micropost) }.to change(Micropost, :count).by(-1)
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:malory))
    assert_select 'a', text: 'delete', count: 0
  end
end

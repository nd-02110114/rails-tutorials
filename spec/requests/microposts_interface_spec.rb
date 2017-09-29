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
    assert_select 'input[type=file]'
    # 無効な送信
    expect { post microposts_path, params: {
      micropost: { content: "" } } }.not_to change(Micropost, :count)
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('spec/fixtures/rails.png', 'image/png')
    expect { post microposts_path, params: {
      micropost: { content: content, picture: picture } } }.to change(Micropost, :count).by(1)
    assert_redirected_to root_url
    assert assigns(:micropost).picture?
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

  it "micropost sidebar count" do
    log_in_with_post(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:mary)
    log_in_with_post(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end

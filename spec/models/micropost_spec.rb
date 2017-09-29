require 'rails_helper'

RSpec.describe Micropost, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  fixtures :microposts
  before do
    @user = FactoryGirl.create(:user)
    @micropost = @user.microposts.build(content: "Lorem ipsum", user_id: @user.id)
  end

  it "should be valid" do
    expect(@micropost).to be_valid
  end

  it "user id should be present" do
    @micropost.user_id = nil
    expect(@micropost).not_to be_valid
  end

  it "content should be present" do
    @micropost.content = ""
    expect(@micropost).not_to be_valid
  end

  it "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    expect(@micropost).not_to be_valid
  end

  it "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

  it "associated microposts should be destroyed" do
    @micropost.save
    expect{ @user.destroy }.to change{ Micropost.count }.by(-1)
  end
end

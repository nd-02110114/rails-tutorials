require 'rails_helper'

RSpec.describe "Relationship Test", type: :request do
  fixtures :users, :relationships

  before do
    @user  = users(:michael)
    @other = users(:mary)
  end

  it "create should require logged-in user" do
    expect { post relationships_path }.not_to change(Relationship, :count)
    assert_redirected_to login_url
  end

  it "destroy should require logged-in user" do
    expect { delete relationship_path(relationships(:one)) }.not_to change(Relationship, :count)
    assert_redirected_to login_url
  end

  it "should follow a user the standard way" do
    log_in_with_post(@user)
    expect { post relationships_path,
      params: { followed_id: @other.id } }.to change(Relationship, :count).by(1)
  end

  it "should follow a user with Ajax" do
    log_in_with_post(@user)
    expect { post relationships_path, xhr: true,
      params: { followed_id: @other.id } }.to change(Relationship, :count).by(1)
  end

  it "should unfollow a user the standard way" do
    log_in_with_post(@user)
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    expect { delete relationship_path(relationship) }.to change(Relationship, :count).by(-1)
  end

  it "should unfollow a user with Ajax" do
    log_in_with_post(@user)
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    expect { delete relationship_path(relationship), xhr: true }.to change(Relationship, :count).by(-1)
  end
end

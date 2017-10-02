require 'rails_helper'

RSpec.describe Relationship, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  fixtures :users

  before do
    @relationship = FactoryGirl.build(:relationship,
                   follower_id: users(:michael).id, followed_id: users(:malory).id)
  end

  it "relationship should be valid" do
    expect(@relationship).to be_valid
  end

  it "should require a follower_id" do
    @relationship.follower_id = nil
    expect(@relationship).not_to be_valid
  end

  it "should require a followed_id" do
    @relationship.followed_id = nil
    expect(@relationship).not_to be_valid
  end

end

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the StaticPagesHelper. For example:
#
# describe StaticPagesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  before do
    @user = FactoryGirl.create(:user)
    remember(@user)
  end

  it "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  it "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.token))
    assert current_user.blank?
  end
end

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
RSpec.describe StaticPagesHelper, type: :helper do
  # pending "add some examples to (or delete) #{__FILE__}"
  it "full title helper" do
    assert_equal full_title, "Ruby on Rails Tutorial Sample App"
    assert_equal full_title("Help"), "Help | Ruby on Rails Tutorial Sample App"
  end
end

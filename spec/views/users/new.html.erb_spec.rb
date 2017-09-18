require 'rails_helper'

RSpec.describe "users/new.html.erb", type: :view do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    @user = User.new
    render :template => "users/new", :layout  => "layouts/application"
  end

  it "get right action path" do
    assert_select 'form[action="/signup"]'
  end
end

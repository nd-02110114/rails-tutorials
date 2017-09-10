require 'rails_helper'

RSpec.describe "static_pages/help.html.erb", type: :view do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    render :template => "static_pages/help", :layout => "layouts/application"
  end

  it "get right help title" do
    expect(rendered).to have_title "Help | Ruby on Rails Tutorial Sample App"
  end
end

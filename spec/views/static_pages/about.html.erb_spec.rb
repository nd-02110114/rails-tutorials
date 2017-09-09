require 'rails_helper'

RSpec.describe "static_pages/about.html.erb", type: :view do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    render :template => 'static_pages/about', :layout  => 'layouts/application'
  end

  it 'get right about title' do
    expect(rendered).to have_title 'About | Ruby on Rails Tutorial Sample App'
  end
end

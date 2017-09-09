require 'rails_helper'

RSpec.describe "static_pages/home.html.erb", type: :view do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    render :template => 'static_pages/home', :layout  => 'layouts/application'
  end

  it 'get right home title' do
    expect(rendered).to have_title 'Home | Ruby on Rails Tutorial Sample App'
  end
end

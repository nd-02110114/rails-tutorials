require 'rails_helper'

RSpec.describe "static_pages/contact.html.erb", type: :view do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    render :template => 'static_pages/contact', :layout  => 'layouts/application'
  end

  it 'get right contact title' do
    expect(rendered).to have_title 'Contact | Ruby on Rails Tutorial Sample App'
  end
end

require 'rails_helper'

RSpec.describe "Home page link check", type: :request do
  it "layout link check" do
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  it "contact title check" do
    get contact_path
    assert_select "title", full_title("Contact")
  end

  it "signup title check" do
    get signup_path
    assert_select "title", full_title("Sign up")
  end
end

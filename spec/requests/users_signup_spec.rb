require 'rails_helper'

RSpec.describe "Users Invalid Sign Up Test", type: :request do
  before do
    visit signup_path
    fill_in "Name",         with: ""
    fill_in "Email",        with: "user@invalid"
    fill_in "Password",     with: "foo"
    fill_in "Confirmation", with: "bar"
  end

  it "invalid signup information" do
    expect { click_button "Create my account" }.not_to change(User, :count)
  end

  it "error message should appear" do
      click_button "Create my account"
      expect(page).to have_selector("#error_explanation")
      expect(page).to have_selector(".field_with_errors")
  end

end

RSpec.describe "Users Valid Sign Up Test", type: :request do
  before do
    visit signup_path
    fill_in "Name",         with: "Example User"
    fill_in "Email",        with: "user@example.com"
    fill_in "Password",     with: "password"
    fill_in "Confirmation", with: "password"
  end

  it "valid signup information" do
    expect { click_button "Create my account" }.to change(User, :count).by(1)
  end
  
end

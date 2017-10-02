require 'rails_helper'

RSpec.describe "Relationship Test", type: :request do
  fixtures :relationships

  before do

  end

  it "create should require logged-in user" do
    expect { post relationships_path }.not_to change(Relationship, :count)
    assert_redirected_to login_url
  end

  it "destroy should require logged-in user" do
    expect { delete relationship_path(relationships(:one)) }.not_to change(Relationship, :count)
    assert_redirected_to login_url
  end
end

FactoryGirl.define do
  factory :user do
    name "MyString"
    email "mystring@email.com"
    password "foobar"
    password_confirmation "foobar"
  end
end

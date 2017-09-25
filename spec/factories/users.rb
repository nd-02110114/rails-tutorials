FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  pass = Faker::Internet.password(8)
  factory :user do
    name                  Faker::Name.name
    email                 Faker::Internet.unique.email
    password              'password'
    password_confirmation 'password'
  end

  factory :other_user, class: User do
    name                  "Sterling Archer"
    email                 "duchess@example.gov"
    password              pass
    password_confirmation pass
  end

  factory :user_for_pagination, class: User do
    name                  Faker::Name.name
    email                 { generate(:email) }
    password              'password'
    password_confirmation 'password'
  end

end

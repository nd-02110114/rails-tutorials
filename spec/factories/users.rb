FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  # pass = Faker::Internet.password(8)
  factory :user do
    name                  Faker::Name.name
    email                 Faker::Internet.unique.email
    password              'password'
    password_confirmation 'password'
    activated              true
    activated_at           Time.now
  end

  factory :other_user, class: User do
    name                  "Sterling Archer"
    email                 "duchess@example.gov"
    password              'password'
    password_confirmation 'password'
    activated              true
    activated_at           Time.zone.now
  end

  factory :user_for_pagination, class: User do
    name                  Faker::Name.name
    email                 { generate(:email) }
    password              'password'
    password_confirmation 'password'
    activated              true
    activated_at           Time.zone.now
  end

  factory :admin_user, class: User do
    name                  'Michael Example'
    email                 'michael@example.com'
    password              'password'
    password_confirmation 'password'
    admin                  true
    activated              true
    activated_at           Time.zone.now
  end

end

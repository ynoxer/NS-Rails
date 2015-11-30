FactoryGirl.define do

  factory :user do
    name 'Name'
    password  'Password'
    email 'Email@example.com'
    type 'Free'
  end

  factory :room do
    name 'Name'
    address 'Address'
    price 'Price'
    type 'Draft'
    association :user_id, factory: :user
  end
end
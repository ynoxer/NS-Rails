FactoryGirl.define do  

  factory :user do
    sequence(:name){|n| "name#{n}" }
    password "foobar"
    password_confirmation "foobar"
    sequence(:email){|n| "email#{n}@example.com" }
    state 'Free'
  end

  factory :room do
    name 'Name'
    address 'Address'
    price 'Price'
    state 'Draft'
    association :user_id, factory: :user
  end
end

FactoryBot.define do
  factory :payer do
    name { Faker::Company.name }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
FactoryBot.define do
  factory :transaction do
    payer { FactoryBot.create(:payer) }
    user { FactoryBot.create(:user) }
    points { Faker::Number.between(from: 100, to: 10000) }
    transaction_time { Faker::Time.between(from: DateTime.now - 3, to: DateTime.now) }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
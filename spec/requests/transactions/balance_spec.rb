require "rails_helper"

RSpec.describe "Balance", :type => :request do
  let(:payer1) { FactoryBot.create(:payer) }
  let(:payer2) { FactoryBot.create(:payer) }
  let(:user) { FactoryBot.create(:user) }
  let(:create_transactions) do
    FactoryBot.create(:transaction, user: user, payer: payer1, points: 200)
    FactoryBot.create(:transaction, user: user, payer: payer2, points: 1000)
    FactoryBot.create(:transaction, user: user, payer: payer2, points: -200)
  end
  let(:expected_response) do
    {
      payer1.name => 200,
      payer2.name => 800,
    }
  end

  before { create_transactions }

  it "returns balance of every payer" do
    get api_v1_user_balance_url(user)

    expect(response).to have_http_status(:ok)
    parsed_body = JSON.parse(response.body)
    expect(parsed_body).to eq(expected_response)
  end
end
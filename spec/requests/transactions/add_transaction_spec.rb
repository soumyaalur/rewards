require "rails_helper"

RSpec.describe "Add transaction", :type => :request do
  let(:payer) { FactoryBot.create(:payer) }
  let(:user) { FactoryBot.create(:user) }
  let(:request_params) do
    {
      payer: payer.name,
      points: 1000,
      timestamp: "2020-10-31T10:00:00Z" 
    }
  end

  it "adds a transaction" do
    expect do
      post api_v1_user_add_transaction_url(user), params: request_params
    end.to change { Transaction.count }.by(1)

    expect(response).to have_http_status(:created)
  end
end
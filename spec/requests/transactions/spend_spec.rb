require "rails_helper"

RSpec.describe "Spend", :type => :request do
  let(:dannon) { FactoryBot.create(:payer, name: "DANNON") }
  let(:unilever) { FactoryBot.create(:payer, name: "UNILEVER") }
  let(:miller) { FactoryBot.create(:payer, name: "MILLER COORS") }
  let(:user) { FactoryBot.create(:user) }
  let(:request_params) { { "points": 5000 } }



  context "normal case" do
    let(:create_transactions) do
      FactoryBot.create(:transaction, user: user, payer: dannon, points: 1000, transaction_time: "2020-11-02T14:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: unilever, points: 200, transaction_time: "2020-10-31T11:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: dannon, points: -200, transaction_time: "2020-10-31T15:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: miller, points: 10_000, transaction_time: "2020-11-01T14:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: dannon, points: 300, transaction_time: "2020-10-31T10:00:00Z")
    end
    let(:expected_response) do
      [
        { "payer" => "DANNON", "points" => -100 },
        { "payer" => "UNILEVER", "points" => -200 },
        { "payer" => "MILLER COORS", "points" => -4_700 }
      ]
    end
    before { create_transactions }

    it "deducts points from a user" do
      put api_v1_user_spend_url(user), params: request_params
  
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to eq(expected_response)
    end
  end

  context "when a payer has a negative balance" do
    let(:create_transactions) do
      FactoryBot.create(:transaction, user: user, payer: dannon, points: 1000, transaction_time: "2020-11-02T14:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: unilever, points: 200, transaction_time: "2020-10-31T11:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: dannon, points: -300, transaction_time: "2020-10-31T15:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: miller, points: 10_000, transaction_time: "2020-11-01T14:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: dannon, points: 300, transaction_time: "2020-10-31T10:00:00Z")
    end
    let(:expected_response) do
      [
        { "payer" => "UNILEVER", "points" => -200 },
        { "payer" => "MILLER COORS", "points" => -4_800 }
      ]
    end
    before { create_transactions }

    it "deducts points from a user" do
      put api_v1_user_spend_url(user), params: request_params
  
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to eq(expected_response)
    end
  end

  context "Partial balance" do
    let(:create_transactions) do
      FactoryBot.create(:transaction, user: user, payer: dannon, points: 1000, transaction_time: "2020-11-02T14:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: unilever, points: 200, transaction_time: "2020-10-31T11:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: dannon, points: -300, transaction_time: "2020-10-31T15:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: miller, points: 10_000, transaction_time: "2020-11-01T14:00:00Z")
      FactoryBot.create(:transaction, user: user, payer: dannon, points: 350, transaction_time: "2020-10-31T10:00:00Z")
    end
    let(:expected_response) do
      [
        {"payer"=>"DANNON", "points"=>-50},
        { "payer" => "UNILEVER", "points" => -200 },
        { "payer" => "MILLER COORS", "points" => -4_750 }
      ]
    end
    before { create_transactions }

    it "partially deducts points from a user" do
      put api_v1_user_spend_url(user), params: request_params
  
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to eq(expected_response)
    end
  end
end
require "rails_helper"

RSpec.describe "Payers index", :type => :request do
  let!(:payers) { FactoryBot.create_list(:payer, 10) }
  let(:expected_response) do
    payers.map do |payer|
      {
        "id" => payer.id,
        "name" => payer.name,
      }
    end
  end

  it "returns a list of payers with all the details" do
    get api_v1_payers_url

    expect(response).to have_http_status(:ok)

    parsed_body = JSON.parse(response.body)
    expect(parsed_body).to eq(expected_response)
  end
end
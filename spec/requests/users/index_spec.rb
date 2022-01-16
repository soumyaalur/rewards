require "rails_helper"

RSpec.describe "Users index", :type => :request do
  let!(:users) { FactoryBot.create_list(:user, 10) }
  let(:expected_response) do
    users.map do |user|
      {
        "id" => user.id,
        "first_name" => user.first_name,
        "last_name" => user.last_name,
        "email" => user.email,
      }
    end
  end

  it "returns a list of users with all the details" do
    get api_v1_users_url

    expect(response).to have_http_status(:ok)

    parsed_body = JSON.parse(response.body)
    expect(parsed_body).to eq(expected_response)
  end
end
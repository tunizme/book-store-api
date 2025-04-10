require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe 'POST /api/v1/register' do
    let(:user_attributes) { attributes_for(:user) }

    it 'registers a new user and returns a token' do
      post '/api/v1/register', params: user_attributes.to_json, headers: headers

      expect(response).to have_http_status(:created)
      expect(response_body).to include("token", "user")
      expect(response_body["user"]["email"]).to eq(user_attributes[:email])
    end

    it 'return error when email is missing' do
      post '/api/v1/register', params: {}.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
                                 {
                                   "errors" => [ "Password can't be blank", "Email can't be blank" ]
                                 }
                               )
    end
  end

  describe 'POST /api/v1/login' do
    let!(:user) { create(:user) }

    it 'logins a user and returns a token' do
      post '/api/v1/login', params: {
        email: user.email,
        password: user.password
      }.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(response_body).to include("token", "user")
    end

    it 'fails with wrong password' do
      post '/api/v1/login', params: {
        email: user.email,
        password: 'wrong_password'
      }.to_json, headers: headers

      expect(response).to have_http_status(:unauthorized)
    end
  end
end

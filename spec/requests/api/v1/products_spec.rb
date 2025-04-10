require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  let!(:admin) { create(:user, role: 'admin') }
  let!(:user) { create(:user, role: 'user') }
  let!(:products) { create_list(:product, 5) }

  let(:headers) { { 'Authorization' => "Bearer #{AuthenticationTokenService.encode(admin.id)}",
                    'Content-Type' => 'application/json' } }

  describe 'GET /api/v1/products' do
    it 'returns all products' do
      get '/api/v1/products', headers: headers

      expect(response).to have_http_status(:ok)
      expect(response_body['products'].length).to eq(5)
    end

    let!(:product) { create(:product) }
    it 'return a product' do
      get "/api/v1/products/#{product.id}", headers: headers

      expect(response).to have_http_status(:ok)
    end

  end

  describe 'POST /api/v1/products' do
    let(:product) { attributes_for(:product) }

    it 'creates a new product' do
      post '/api/v1/products', params: product.to_json, headers: headers

      expect(response).to have_http_status(:created)
      expect(response_body["name"]).to eq(product[:name])
    end
  end

  describe 'PUT /api/v1/products/:id' do
    let!(:product) { create(:product) }
    let(:updated_name) { "Su im lang cua bay cho" }

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        put "/api/v1/products/#{product.id}",
            params: { name: updated_name }.to_json

        expect(response).to have_http_status(:unauthorized)
        expect(response_body['error']).to include('Unauthorized')
      end
    end

    context 'when user is not admin' do
      let!(:user) { create(:user, role: 'user') }
      let(:headers) { { "Authorization" => "Bearer #{AuthenticationTokenService.encode(user.id)}",
                        "Content-Type" => "application/json" } }

      it 'return forbidden' do
        put "/api/v1/products/#{product.id}",
            params: { name: updated_name }.to_json, headers: headers

        expect(response).to have_http_status(:forbidden)
        expect(response_body["errors"]).to include('Forbidden: Admin only')
      end
    end

    context 'when user is admin' do
      it 'updates an existing product' do
        put "/api/v1/products/#{product.id}",
            params: { name: updated_name }.to_json,
            headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body["name"]).to eq(updated_name)
      end
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    let!(:product) { create(:product) }

    it 'deletes the product' do
      expect {
        delete "/api/v1/products/#{product.id}", headers: headers
      }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
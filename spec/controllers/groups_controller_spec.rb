require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
    describe 'GET #index' do
    it 'returns a 200 status code' do
        get :index
        expect(response.status).to eq(200)
        # expect(response).to have_http_status(:ok)
    end
        it 'returns an array body'
        it 'returns group attributes'
        it 'filter by name'
    end
end
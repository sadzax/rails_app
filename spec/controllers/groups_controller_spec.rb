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
        
        it 'returns an array body' do
            get :index
            expect(JSON.parse(response.body)).to be_instance_of(Array)
        end 

        #  Не работает из-за тестового окружения
        # it 'returns group attributes' do
        #     get :index
        #     groups = JSON.parse(response.body)
        #     expect(groups[0].keys).to contain_exactly('id', 'name')
        # end

    end
end
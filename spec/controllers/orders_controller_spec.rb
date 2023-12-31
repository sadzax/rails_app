require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
    describe 'GET #check' do
        get :show, params: { id: 4567 }, session: { user_id: 4567 }
        # let(:user) { create(:user, balance: 50000) }
        let(:valid_params) { { cpu: 2, ram: 8, hdd_type: 'ssd', hdd_capacity: 512, balance: 50000 } }
        let(:invalid_params) { { cpu: 336, ram: 445, hdd_type: 'эйч-ди-ди', hdd_capacity: 1024, balance: 1 } }
        before do 
            allow(controller).to receive(:set_user) { user }
            response_double = double('Response', status: 200, body: 'Test is done')
            allow_any_instance_of(HTTPClient).to receive(:get).and_return(response_double)
        end
        
        allow_any_instance_of(HTTPClient).to receive(:get)
        and_return(double('Response', status: 200, body: 'Test is done'))

        context 'user is authenticated' do
            before { sign_in user }

            context 'valid params' do
                #  Нормальное поведение
                context '#check' do
                    it 'return JSON response { result: true + data } ' do
                        #  Проверка соединения 
                        get :check, params: valid_params
                        #  Ожидаемый результат успешный 
                        expect(response).to have_http_status(:success)
                        expect(response.body).to eq({
                            result: true,
                            total: 10549.12,
                            balance: 50000,
                            balance_after_transaction: 39450,88}.to_json)
                    end
                end
                
                #  Недостаток денег на счету
                context 'not enough balance' do
                    it 'returns JSON response { result: false } + error Not Acceptable' do
                        #  Проверка соединения 
                        valid_params_but_not_enough_balance = valid_params
                        valid_params_but_not_enough_balance[:balance] = 300
                        #  Ожидаем 406
                        get :check, params: valid_params_but_not_enough_balance
                        expect(response).to have_http_status(:not_acceptable)
                        expect(response.body).to eq({
                            result: false,
                            error: 'Not Acceptable'}.to_json)
                    end
                end
            end

            #  Неправильные параметры
            context 'invalid params' do
                it 'returns JSON response { result: false } + error Not Acceptable' do
                    #  Проверка соединения 
                    #  Ожидаем 406
                    it '406 status code' do
                        get :check, params: invalid_params
                        expect(response).to have_http_status(:not_acceptable)
                        expect(response.body).to eq({
                            result: false,
                            error: 'Not Acceptable'}.to_json)
                    end
                end
            end

            #  Если сервис лежит
            context 'costcalc service is unavailable' do
                it 'returns JSON response { result: false } + error Service Unavailable' do
                    #  Эмуляция отсутствия соединения
                    allow_any_instance_of(HTTPClient).to receive(:get).and_raise(StandardError)
                    #  Ожидаем 503
                    get :check, params: valid_params
                    expect(response).to have_http_status(:service_unavailable)
                    expect(response.body).to eq({
                        result: false,
                        error: 'Service Unavailable'}.to_json)
                end
            end
        
            context 'when user is not authenticated' do
                it 'returns a JSON response with error Unauthorized' do
                        #  Эмуляция отсутствия авторизации
                        # allow(controller).to receive(:authenticate_user!).and_raise(Devise::FailureApp::UnauthorizedError)
                        session[:login] = "test"
                        get :check, params: valid_params
                        expect(response).to have_http_status(:unauthorized)
                        expect(response.body).to eq({
                    error: 'Unauthorized'}.to_json)
                end
            end
        end
    end
end

class GrapeApi
    class VmsApi < Grape::API
        format :json
        namespace :vms do
            get do
                present Vm.all
            end 
        end
    end
end
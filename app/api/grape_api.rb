class GrapeAPI < Grape::API
    mount VmsAPI
end

namespace :vms do
 
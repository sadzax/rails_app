class GrapeApi
    module Entities
        class Vm < Grape::Entity
            expose :id
            expose :configuration

            def configuration
                "#{object.cpu} CPU/#{object.ram} Gb"
            end
        end
    end
end
           
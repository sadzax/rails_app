class GrapeApi < Grape::API
  mount VmsApi
  mount ProjectsApi
end

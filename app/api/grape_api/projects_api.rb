class GrapeApi
    class ProjectsApi < Grape::API
        format :json
        namespace :projects do
            params do
                optional :stage, type: String
            end
            get do
                projects = Project.all
                projects = projects.where('stage == :stage', stage: params[:stage]) if params[:stage].present?
                present projects
            end
            route_param :id, type: Integer do
                get do
                    projects = Project.find_by_id(params[:id])
                    error!({ message: 'Проект не найден' }, 404) unless projects
                    present projects
                end
                delete do
                    projects = Project.find_by_id(params[:id])
                    error!({ message: 'Данный проект не найден' }, 404) unless projects
                    projects.destroy
                    status 204
                end
            end 
        end
    end
end
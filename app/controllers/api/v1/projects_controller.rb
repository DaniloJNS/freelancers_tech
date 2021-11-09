class Api::V1::ProjectsController < ActionController::API
  def index
    @project = Project.all
    render json: @project
  end
  def show
    @project = Project.find(params[:id])

    render json: @project
  end
end

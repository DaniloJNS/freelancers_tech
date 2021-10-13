class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index]
  before_action :profile_complete_professsional!, only: [:show]

  layout 'main'
  def show
    @project = Project.find(params[:id])
  end
  def index
    @projects = current_user.project
  end
  def new
    @project = Project.new
  end
  def create
    @project = Project.new(params_private)
    if @project.save
      redirect_to project_path(@project)
    else
      render 'new'
    end
  end
  def public
    @projects = Project.all
  end

  private
  def params_private
    {user_id: current_user.id, **params.require(:project).permit(:title,:description,:deadline_submission, :max_price_per_hour,
                                   :remote)}
  end
end

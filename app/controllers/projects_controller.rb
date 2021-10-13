class ProjectsController < ApplicationController
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
    @project.user = current_user
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
    params.require(:project).permit(:title,:description,:deadline_submission, :max_price_per_hour,
                                   :remote)
  end
end

class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
  end
  def index
    @projects = Project.all
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
  private
  def params_private
    params.require(:project).permit(:title,:description,:deadline_submission)
  end
end

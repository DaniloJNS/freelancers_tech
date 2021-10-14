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
    @project = Project.new(project_params)
    if @project.save
      redirect_to project_path(@project)
    else
      render 'new'
    end
  end
  def public
    @projects = Project.all
  end
  def search
    parameter = search_params
    @projects = Project.where('title like ? OR description like ?',
                             "%#{parameter}%", "%#{parameter}%")
    if @projects.blank?
      @projects = Project.all
      flash[:alert] =  'Sua pesquisa não encontrou nenhum projeto correspondente'
    end

    render :public
  end
  private
  def project_params
    {user_id: current_user.id, **params.require(:project).permit(:title,:description,:deadline_submission, :max_price_per_hour,
                                   :remote)}
  end
  def search_params
    params.require(:q)
  end
end

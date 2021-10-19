class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index]
  before_action :profile_complete_professsional!, only: [:show]

  def show
    @project = Project.find(params[:id])
    @proposal = Proposal.new
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
  def update
    if update_params  
      @project = Project.find(update_params[:id])
      @project.update!(status: update_params[:status])
      redirect_to projects_path, notice: 'Inscrições encerradas com sucesso'
    else
      redirect_to projects_path, alert: 'Não foi possível realizar essa operação'
    end
  end

  def public
    @projects = Project.where("status = 0")
  end

  def search
    parameter = search_params
    @projects = Project.where('(title like ? OR description like ?) and status = ?', "%#{parameter}%",
                              "%#{parameter}%", 0)
    if @projects.blank?
      @projects = Project.where("status = 0")
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
    params[:q].present? ? params.require(:q) : "@#$!@"
  end
  def update_params
    params[:status].present? ? {status: params.require(:status), id: params.require(:id)} 
    : false
  end
end

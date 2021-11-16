# frozen_string_literal: true

# comments here
class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create index closed]
  before_action :find_project, only: %i[team show]

  def public
    @projects = Project.available
  end

  def index
    @projects = current_user.projects
  end

  def team; end

  def show
    @proposal = Proposal.new
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

  def closed
    if closed_params
      @project = Project.find(closed_params[:id])
      @project.update!(status: closed_params[:status])
      redirect_to projects_path, notice: 'Inscrições encerradas com sucesso'
    else
      redirect_to projects_path, alert: 'Não foi possível realizar essa operação'
    end
  end

  def search
    @projects = Project.search(search_params)
    if @projects.blank?
      @projects = Project.available
      flash[:alert] = 'Sua pesquisa não encontrou nenhum projeto correspondente'
    end

    render :public
  end

  private

  def find_project
    @project = Project.find(params[:id])
  end

  def project_params
    { user_id: current_user.id, **params.require(:project).permit(:title, :description, :deadline_submission,
                                                                  :max_price_per_hour, :remote) }
  end

  def search_params
    params[:q].present? ? params.require(:q) : "@#{$ERROR_INFO}@"
  end

  def closed_params
    if params[:status].present?
      { status: params.require(:status), id: params.require(:id) }
    else
      false
    end
  end
end

class ProposalsController < ApplicationController
  before_action :authenticate_professional!, only: [:create]
  before_action :authenticate_professional_user!, only: [:show]

  def index
    @proposals = Project.find(params[:project_id]).proposal
  end
  def create
    @proposal = current_professional.proposal.build(proposal_params)
    if @proposal.save
      redirect_to(proposal_path(@proposal), notice: 'Proposta enviada com sucesso!')
    else
      @project = Project.find(params[:project_id])
      render 'projects/show'
    end
  end
  def show
    @proposal = Proposal.find(params[:id])
  end
  def update
    @proposal = Proposal.find(params[:id])
    @proposal.status = params[:status]
    @proposal.feedback = params[:feedback] if @proposal.refused?
    if @proposal.save
      redirect_to(proposal_path(@proposal), notice: 'Proposta aceita com sucesso!')
    else
      @params = params
      render :show
    end
  end
  private
  def update_proposal_params
    params.require(:id, :status)
  end
  def proposal_params
    {project_id: params[:project_id], **params.require(:proposal)
      .permit(:justification, :price_hour, :weekly_hour, :completion_deadline)}
  end
end
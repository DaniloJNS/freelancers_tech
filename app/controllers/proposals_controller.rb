class ProposalsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :approval,
  :accepted, :refused]
  before_action :authenticate_professional!, only: [:create]
  before_action :authenticate_professional_user!, only: [:show]

  def index
    @proposals = Project.find(params[:project_id]).proposals.where(
      "status <> ?", "3")
  end

  def create
    @proposal = current_professional.proposals.build(proposal_params)
    if @proposal.save
      redirect_to(proposal_path(@proposal), notice: 'Proposta enviada com sucesso!')
    else
      @project = Project.find(params[:project_id])
      render 'projects/show'
    end
  end

  def show
    @proposal = Proposal.find(params_id)
  end

  def approval
    @proposal = Proposal.find(params_id)
    unless @proposal.pending?
      redirect_to proposal_path(@proposal, status: :moved_permanently)
    end
  end
  
  def accepted
    @proposal = Proposal.find(params_id)
    if @proposal.update(status: 'accepted')
      redirect_to proposal_path(@proposal), notice: "Proposta aceita com sucesso"
    else
      redirect_to proposal_path(@proposal)
      exption_proposal
    end
  end
  def cancel
    @proposal = Proposal.find(params_id)
    @proposal.feedback = feedback_params
    @proposal.status = "cancel"
    if @proposal.save
      redirect_to(proposal_path(@proposal), notice: "Proposta cancelada com sucesso")
    else
      @proposal.status = "accepted"
      exption_proposal
      render :show
    end
  end
  def refused
    @proposal = Proposal.find(params_id)
    @proposal.feedback = feedback_params
    @proposal.status = "refused"
    if @proposal.save
      redirect_to(proposal_path(@proposal), notice: "Proposta recusada com sucesso")
    else
      @proposal.status = "pending"
      exption_proposal
      render :approval
    end
  end
  private
  def proposal_params
    {project_id: params[:project_id], **params.require(:proposal)
      .permit(:justification, :price_hour, :weekly_hour, :completion_deadline)}
  end
  def feedback_params
    params[:feedback].present? ? params.require(:feedback) : ""
  end
  def params_id
    params.require(:id)
  end
  def exption_proposal
    flash[:alert] = "Não foi possível realizar essa operação"
  end
end

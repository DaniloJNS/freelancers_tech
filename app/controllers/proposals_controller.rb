# frozen_string_literal: true

# comments here
class ProposalsController < ApplicationController
  before_action :authenticate_user!, only: %i[index approval
                                              accepted refused]
  before_action :authenticate_professional!, only: [:create]
  before_action :authenticate_professional_user!, only: [:show]

  def index
    @proposals = Project.find(params[:project_id]).proposals.available
  end

  def create
    @proposal = current_professional.proposals.build(proposal_params)
    if @proposal.save
      ProposalMailer.with(proposal: @proposal).notify_new_proposal.deliver_now
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
  end

  def accepted
    @proposal = Proposal.find(params_id)
    @proposal.update(status: 'accepted')
    @proposals = @proposal.project.proposals.available
    respond_sucess notice: 'Proposta aceita com sucesso'
  end

  def refused
    @proposal = Proposal.find(params_id)
    if @proposal.update(status: 'refused', feedback: feedback_params)
      @proposals = @proposal.project.proposals.available
      return respond_sucess notice: 'Proposta recusada com sucesso'
    end
    @proposal.status = 'pending'
    respond_to do |format|
      format.js
      format.html { render :approval }
    end
  end

  def cancel
    @proposal = Proposal.find(params_id)
    if @proposal.update(status: 'cancel', feedback: feedback_params)
      redirect_to(proposal_path(@proposal), notice: 'Proposta cancelada com sucesso')
    else
      @proposal.status = 'accepted'
      exption_proposal
      render :show
    end
  end

  private

  def respond_sucess(notice:)
    respond_to do |format|
      format.js { render :index, notice: notice }
      format.html { redirect_to proposal_path(@proposal), notice: notice }
    end
  end

  def proposal_params
    { project_id: params[:project_id], **params.require(:proposal)
                                               .permit(:justification, :price_hour, :weekly_hour,
                                                       :completion_deadline) }
  end

  def feedback_params
    params[:feedback].present? ? params.require(:feedback) : ''
  end

  def params_id
    params.require(:id)
  end

  def exption_proposal
    flash[:alert] = 'Não foi possível realizar essa operação'
  end
end

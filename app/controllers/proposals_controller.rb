# frozen_string_literal: true

# comments here
class ProposalsController < ApplicationController
  before_action :authenticate_user!, only: %i[index approval
                                              accepted refused]
  before_action :authenticate_professional!, only: [:create]
  before_action :authenticate_professional_user!, only: [:show]
  before_action :find_proposal, only: %i[accepted refused cancel approval show]

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

  def show; end

  def approval; end

  def accepted
    @proposal.update(status: 'accepted')
    respond_success proposal: @proposal, notice: 'Proposta aceita com sucesso'
  end

  def refused
    if @proposal.update(status: 'refused', feedback: feedback_params)
      respond_success proposal: @proposal, notice: 'Proposta recusada com sucesso'
      return
    end
    @proposal.status = 'pending'
    respond_to do |format|
      format.js
      format.html { render :approval }
    end
  end

  def cancel
    if @proposal.update(status: 'cancel', feedback: feedback_params)
      redirect_to(proposal_path(@proposal), notice: 'Proposta cancelada com sucesso')
      return
    end
    @proposal.status = 'accepted'
    exption_proposal
    render :show
  end

  private

  def find_proposal
    @proposal = Proposal.find(params_id)
  end

  def proposals_available(proposal)
    @proposals = proposal.project.proposals.available
  end

  def respond_success(notice:, proposal:)
    proposals_available proposal
    respond_to do |format|
      format.js { render :index, notice: notice }
      format.html { redirect_to proposal_path(@proposal), notice: notice }
    end
  end

  def proposal_params
    params.require(:proposal).permit(:justification, :price_hour, :weekly_hour, :completion_deadline)
          .merge({ project_id: params.require(:project_id) })
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

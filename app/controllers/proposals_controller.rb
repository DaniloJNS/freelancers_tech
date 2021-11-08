# frozen_string_literal: true

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
    if @proposal.update(status: 'accepted')
      respond_to do |format|
        @proposals = @proposal.project.proposals.available
        format.js { render :index, notice: 'Proposta aceita com sucesso' }
        format.html { redirect_to proposal_path(@proposal), notice: 'Proposta aceita com sucesso' }
      end
    else
      exption_proposal
      respond_to do |format|
        format.js { redirect_to project_proposals_path(@proposal.project) }
        format.html { redirect_to proposal_path(@proposal) }
      end
    end
  end

  def cancel
    @proposal = Proposal.find(params_id)
    @proposal.feedback = feedback_params
    @proposal.status = 'cancel'
    if @proposal.save
      redirect_to(proposal_path(@proposal), notice: 'Proposta cancelada com sucesso')
    else
      @proposal.status = 'accepted'
      exption_proposal
      render :show
    end
  end

  def refused
    @proposal = Proposal.find(params_id)
    @proposal.feedback = feedback_params
    @proposal.status = 'refused'
    if @proposal.save
      respond_to do |format|
        @proposals = @proposal.project.proposals.available
        format.js { render :index, notice: 'Proposta recusada com sucesso' }
        format.html { redirect_to(proposal_path(@proposal), notice: 'Proposta recusada com sucesso') }
      end
    else
      @proposal.status = 'pending'
      respond_to do |format|
        format.js
        format.html { render :approval }
      end
    end
  end

  private

  def proposal_params
    { project_id: params[:project_id], **params.require(:proposal)
                                               .permit(:justification, :price_hour, :weekly_hour, :completion_deadline) }
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

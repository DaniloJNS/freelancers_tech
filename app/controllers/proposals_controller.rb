class ProposalsController < ApplicationController
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
  
  private
  def proposal_params
    {project_id: params[:project_id], **params.require(:proposal)
      .permit(:justification, :price_hour, :weekly_hour, :completion_deadline)}
  end
end

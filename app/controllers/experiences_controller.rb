class ExperiencesController < ApplicationController
  before_action :authenticate_professional! 
  def new
    @profile = Profile.find(profile_params)
    @experience = Experience.new
  end

  def create
    @experience = Experience.new(experience_params)
    if @experience.save
      redirect_to(root_path, notice: "Experiência registrada com sucesso")
    else
      render :new
    end
  end

  private
  def experience_params
    {profile_id: profile_params, **params.require(:experience)
      .permit(:company, :office, :description, :start_date, :end_date,
	     :current_job)}
  	
  end
  def profile_params
    params.permit(:profile_id)[:profile_id]
  end
end

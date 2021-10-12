class ProfilesController < ApplicationController
  def new
    @profile = Profile.new
  end
  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      redirect_to root_path, notice: 'Seu perfil está completo!'
    else
      render :new 
    end
  end

  private
  def profile_params
    {professional_id: current_professional.id, **params.require(:profile)
      .permit(:name, :social_name, :birth_date, :description)}
  end
end

# frozen_string_literal: true

module Professionals
  # comments here
  class ProfilesController < ApplicationController
    before_action :authenticate_professional!, only: %i[new create]
    skip_before_action :profile_complete_professsional!, only: %i[new create]

    def new
      @profile = Profile.new
    end

    def create
      @profile = Profile.new(profile_params)
      if @profile.save
        redirect_to new_professional_profile_formation_path(@profile), notice: 'Seu perfil está completo!'
      else
        render :new
      end
    end

    def show
      @profile = Profile.find params.require(:id)
    end

    private

    def profile_params
      params.require(:profile).permit(:name, :social_name, :birth_date, :description)
            .merge({ professional_id: current_professional.id })
    end
  end
end

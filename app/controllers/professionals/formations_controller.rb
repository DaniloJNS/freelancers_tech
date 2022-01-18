# frozen_string_literal: true

module Professionals
  # Comments here
  class FormationsController < ApplicationController
    before_action :authenticate_professional!, only: %i[new create]

    def new
      @formation = Formation.new
      @profile = Profile.find(profile_params)
    end

    def create
      @formation = Formation.new(formation_params)
      if @formation.save
        redirect_to new_professional_profile_experience_path(@formation.profile),
                    notice: 'Formação registrada com sucesso'
      else
        render :new
      end
    end

    private

    def formation_params
      params.require(:formation).permit(:university, :start, :conclusion, :status)
            .merge({ profile_id: profile_params })
    end

    def profile_params
      params.require(:profile_id)
    end
  end
end

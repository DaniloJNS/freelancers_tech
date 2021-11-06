# frozen_string_literal: true

class FormationsController < ApplicationController
  before_action :authenticate_professional!, only: [new]

  def new
    @formation = Formation.new
    @profile = Profile.find(profile_params)
  end

  def create
    @formation = Formation.new(formation_params)
    if @formation.save
      redirect_to root_path, notice: 'Formação registrada com sucesso'
    else
      render :new
    end
  end

  private

  def formation_params
    { profile_id: profile_params, **params.require(:formation)
                                          .permit(:university, :start, :conclusion, :status) }
  end

  def profile_params
    params.permit(:profile_id)[:profile_id]
  end
end

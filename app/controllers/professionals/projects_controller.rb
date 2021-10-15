class Professionals::ProjectsController < ApplicationController
  before_action :profile_complete_professsional!, only: [:index]
  def index
    @projects = current_professional.project
  end
end

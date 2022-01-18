# frozen_string_literal: true

module Professionals
  # comments here
  class ProjectsController < ApplicationController
    before_action :profile_complete_professsional!, only: [:index]
    def index
      @projects = Project.teams(current_professional)
    end

    def team
      @project = Project.find(params.require(:project_id))
    end
  end
end

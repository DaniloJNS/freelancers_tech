# frozen_string_literal: true

module Professionals
  # comments here
  class ProjectsController < ApplicationController
    before_action :profile_complete_professsional!, only: [:index]
    def index
      @projects = current_professional.projects
    end
  end
end

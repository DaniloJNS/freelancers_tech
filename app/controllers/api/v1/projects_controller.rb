# frozen_string_literal: true

module Api
  module V1
    # comments here
    class ProjectsController < ActionController::API
      def index
        @project = Project.all
        render json: @project
      end

      def show
        @project = Project.find(params[:id])

        render json: @project
      end
    end
  end
end

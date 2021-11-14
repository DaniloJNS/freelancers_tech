# frozen_string_literal: true

# comments here
class HomeController < ApplicationController
  def index
    @projects = Project.all
    @resource = Professional.new
  end

  def ajax
    @notification = NotificationComponent.new(type: 'notice', data: 'veio pelo ajax')
    respond_to do |format|
      format.js
    end
  end
end

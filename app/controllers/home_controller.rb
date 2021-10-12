class HomeController < ApplicationController
  def index
    @projects = Project.all
    @resource = Professional.new
  end
end

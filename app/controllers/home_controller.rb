class HomeController < ApplicationController
  layout 'main'
  def index
    @projects = Project.all
    @resource = Professional.new
  end
end

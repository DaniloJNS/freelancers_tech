class UpdateProjectStatusJob
  include Sidekiq::Job

  def perform 
    @project = Project.open.where("deadline_submission > CURRENT_DATE")
    @project.map(&:closed!)
  end
end

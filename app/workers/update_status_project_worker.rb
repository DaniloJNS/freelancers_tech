class UpdateStatusProjectWorker
  include Sidekiq::Worker

  def perform 
    @project = Project.open.where("deadline_submission > CURRENT_DATE")
    @project.map(&:closed!)
  end
end

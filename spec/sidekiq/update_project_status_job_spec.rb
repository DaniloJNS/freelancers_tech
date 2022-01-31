require 'rails_helper'

RSpec.describe UpdateProjectStatusJob, type: :job do
  include ActiveSupport::Testing::TimeHelpers
  context 'queues' do
    it '#create job' do
      UpdateProjectStatusJob.perform_async

      expect(UpdateProjectStatusJob.jobs.size).to eq 1
      expect(Sidekiq::Queues["default"].size).to eq 1 
      expect(nil).to eq Sidekiq::Queues["default"].first['args'][0]
    end
  end

  context 'schedule update' do
    it 'successfully' do
      project = create(:project, deadline_submission: 2.day.from_now, status: "open")

      travel_to 3.day.from_now do
        UpdateProjectStatusJob.new.perform

        project.reload
        expect(project.status).to eq 'closed' 
      end
    end
  end
end

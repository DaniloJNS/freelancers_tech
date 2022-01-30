require 'rails_helper'

RSpec.describe UpdateProjectStatusJob, type: :job do
  include ActiveSupport::Testing::TimeHelpers

  context 'schedule update' do
    it 'successfully' do
      project = create(:project, deadline_submission: 2.day.from_now, status: "open")

      travel_to 3.day.from_now do
        project.reload
        expect(project.status).to eq 'closed' 
      end
    end

    it 'can not update status before deadline' do
      project = create(:project, deadline_submission: 2.day.from_now, status: "open")

      travel_to 1.day.from_now do
        project.reload
        expect(project.status).to eq 'open' 
      end
    end

    context 'every day' do
      let(:project_first) { create(:project, deadline_submission: 2.day.from_now, status: "open") }
      let(:project_second) { create(:project, deadline_submission: 3.day.from_now, status: "open") }
      let(:project_third) { create(:project, deadline_submission: 4.day.from_now, status: "open") }
      
      it '3 days later' do
        project_first.reload
        project_second.reload
        project_third.reload

        travel_to 3.day.from_now do
          project_first.reload
          project_second.reload
          project_third.reload

          expect(project_first.status).to eq 'closed' 
          expect(project_second.status).to eq 'open' 
          expect(project_third.status).to eq 'open' 
        end
      end
      it '4 days later' do
        project_first.reload
        project_second.reload
        project_third.reload

        travel_to 4.day.from_now do
          project_first.reload
          project_second.reload
          project_third.reload

          expect(project_first.status).to eq 'closed' 
          expect(project_second.status).to eq 'closed' 
          expect(project_third.status).to eq 'open' 
        end
      end
      it '5 days later' do
        project_first.reload
        project_second.reload
        project_third.reload

        travel_to 5.day.from_now do
          project_first.reload
          project_second.reload
          project_third.reload

          expect(project_first.status).to eq 'closed' 
          expect(project_second.status).to eq 'closed' 
          expect(project_third.status).to eq 'closed' 
        end
      end
    end
  end
end

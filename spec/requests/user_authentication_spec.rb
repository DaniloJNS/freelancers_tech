require 'rails_helper'

describe 'user authentication' do
  context 'cannot' do

    #projects
    it 'create project without login' do
      post projects_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'open new project form unless authenticated' do
      get new_project_path

      expect(response).to redirect_to(new_user_session_path)
    end
    it 'open index project view unless authenticated' do
      get projects_path

      expect(response).to redirect_to(new_user_session_path)
    end
    it 'closed a project' do
      post closed_project_path(1)

      expect(response).to redirect_to(new_user_session_path)
    end

    # proposals
    it 'view index of proposals without login' do
      get project_proposals_path(project_id: 1)
      
      expect(response).to redirect_to(new_user_session_path)
    end
    it 'approval a proposals without login' do
      get approval_proposal_path(1)

      expect(response).to redirect_to(new_user_session_path)
    end
    it 'accepted proposals without login' do
      post accepted_proposal_path(1)

      expect(response).to redirect_to(new_user_session_path)
    end
    it 'refused proposals without login' do
      post refused_proposal_path(1)

      expect(response).to redirect_to(new_user_session_path)
    end
    it 'view a proposal without login' do
      get proposal_path(id: 1)
      
      expect(response).to redirect_to(root_path)
    end
  end
  # TODO Routes for propostas
end

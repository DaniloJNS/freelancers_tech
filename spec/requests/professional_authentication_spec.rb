require 'rails_helper'

describe 'professional authentication' do
  context 'cannot' do
    it 'create profile without login' do
      post professional_profiles_path(professional_id: 1)

      expect(response).to redirect_to(new_professional_session_path)
    end
    it 'open profile form unless authenticated' do
      get new_professional_profile_path(professional_id: 1)

      expect(response).to redirect_to(new_professional_session_path)
    end
    it 'create proposal without login' do
      post project_proposals_path(project_id: 1)

      expect(response).to redirect_to(new_professional_session_path) 
    end
    it 'view a proposal without login' do
      get proposal_path(id: 1)
      
      expect(response).to redirect_to(root_path)
    end
  end
end

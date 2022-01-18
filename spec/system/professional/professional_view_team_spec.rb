# frozen_string_literal: true

require 'rails_helper'

describe 'professional view team' do
  context 'successfully' do
    it 'using link' do
      professional = create(:professional)
      proposal = create(:proposal, project_closed: true, professional: professional)
      proposal.accepted!

      login_as professional, scope: :professional
      visit root_path
      click_on 'Meus Projetos'

      expect(current_path).to eq(professional_projects_path(professional.profile.name))
      expect(page).to have_link('Ver Time', href: professional_project_team_path(proposal.project))
    end
    it 'in view' do
      project = create(:project)
      professional = create(:professional)
      professional_two_ = create(:professional)
      proposal = create(:proposal, status: 'accepted', project: project, professional: professional)
      create(:proposal, status: 'accepted', project: project, professional: professional_two_)
      project.closed!

      login_as professional, scope: :professional
      visit root_path
      click_on 'Meus Projetos'
      click_on 'Ver Time'

      expect(current_path).to eq(professional_project_team_path(proposal.project))
      expect(page).to have_content(professional.profile.name)
      expect(page).to have_content(professional_2.profile.name)
    end
  end
end

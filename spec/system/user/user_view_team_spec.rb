# frozen_string_literal: true

require 'rails_helper'

describe 'user view team' do
  include ActiveSupport::Testing::TimeHelpers
  context 'using link' do
    it 'after finishing receipt of proposals' do
      user = create(:user)
      project = create(:project, user: user, deadline_submission: 2.days.from_now)
      create_list(:proposal, 10, project: project)

      login_as user, scope: :user
      visit projects_path
      click_on 'Encerrar Inscrições'

      expect(page).to have_link('Visualizar time', href: team_project_path(project))
      expect(page).to_not have_link('Encerrar Inscrições')
    end
    it 'after deadline submission finish' do
      user = create(:user)
      project = create(:project, user: user, deadline_submission: 2.days.from_now)
      create_list(:proposal, 2, project: project)

      travel_to 3.days.from_now do
        UpdateProjectStatusJob.new.perform
        login_as user, scope: :user
        visit projects_path(project)

        expect(page).to have_link('Visualizar time', href: team_project_path(project))
        expect(page).to_not have_link('Encerrar Inscrições')
      end
    end
  end
  it 'successfully' do
    user = create(:user)
    project = create(:project, user: user, deadline_submission: 2.days.from_now)
    danilo = create(:professional)
    caio = create(:professional)
    create(:proposal, project: project, professional: danilo)
    create(:proposal, project: project, professional: caio)

    travel_to 3.days.from_now do
      UpdateProjectStatusJob.new.perform
      login_as user, scope: :user
      visit projects_path(project)
      click_on 'Visualizar time'

      expect(current_path).to eq(team_project_path(project))
      expect(page).to have_content(danilo.profile.name)
      expect(page).to have_content(caio.profile.name)
    end
  end
  it 'successfully and can view profiles using link' do
    user = create(:user)
    project = create(:project, user: user, deadline_submission: 2.days.from_now)
    danilo = create(:professional)
    caio = create(:professional)
    create(:proposal, project: project, professional: danilo)
    create(:proposal, project: project, professional: caio)

    travel_to 3.days.from_now do
      login_as user, scope: :user
      visit team_project_path(project)

      expect(page).to have_link(danilo.profile.name, href: profile_path(danilo.profile))
      expect(page).to have_link(caio.profile.name, href: profile_path(caio.profile))
    end
  end
end

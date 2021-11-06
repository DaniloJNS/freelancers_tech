# frozen_string_literal: true

require 'rails_helper'

describe 'user ends registrations' do
  include ActiveSupport::Testing::TimeHelpers
  it 'using button' do
    danilo = create(:user)

    blog = create(:project, user: danilo)

    login_as danilo, scope: :user
    visit projects_path

    expect(page).to have_button('Encerrar Inscrições')
  end
  it 'successfully' do
    danilo = create(:user)

    blog = create(:project, user: danilo)

    login_as danilo, scope: :user
    visit projects_path
    click_on 'Encerrar Inscrições'

    expect(page).to have_content('Inscrições encerradas com sucesso')
    expect(page).to_not have_button('Encerrar Inscrições')
    expect(page).to have_link('Visualizar time')
  end
  it 'out deadline' do
    danilo = create(:user)

    blog = create(:project, user: danilo, deadline_submission: 1.week.from_now)

    travel_to 2.weeks.from_now do
      login_as danilo, scope: :user
      visit projects_path

      expect(page).to have_link('Visualizar time')
      expect(page).to_not have_link('Encerrar Inscrições')
    end
  end
end

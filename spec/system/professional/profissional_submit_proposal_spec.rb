# frozen_string_literal: true

require 'rails_helper'

describe 'profissional submit proposal' do
  include ActiveSupport::Testing::TimeHelpers
  it 'successfully' do
    blog = create(:project, remote: false)
    portal_escolar = create(:project)

    danilo = create(:professional)
    create(:profile, professional: danilo)

    login_as danilo, scope: :professional

    visit project_path(blog)

    fill_in 'Justificativa', with: 'Sou um gênio'
    fill_in 'Valor/Hora', with: '100'
    fill_in 'Horas por semana', with: '20'
    fill_in 'Prazo de conclusão', with: 50
    click_on 'Enviar'

    expect(current_path).to_not eq(project_path(blog))
    expect(page).to have_content('Proposta enviada com sucesso!')
    expect(page).to have_content('Sou um gênio')
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content(/20/)
    expect(page).to have_content(/50/)
    expect(page).to have_content(danilo.profile.name)
    expect(page).to have_content(danilo.email)
  end
  # TODO: Um usuario não pode fazer mais de uma proposta
  it 'with fields empty' do
    blog = create(:project, remote: false)
    portal_escolar = create(:project)

    danilo = create(:professional)
    create(:profile, professional: danilo)

    login_as danilo, scope: :professional

    visit project_path(blog)
    click_on 'Enviar'

    expect(page).to have_content('Justificativa não pode ficar em branco')
    expect(page).to have_content('Preço por hora não pode ficar em branco')
    expect(page).to have_content('Horas por semana não pode ficar em branco')
    expect(page).to have_content('Prazo de conclusão não pode ficar em branco')
  end
  it 'two times in same projeto' do
    blog = create(:project, remote: false)

    danilo = create(:professional)
    create(:profile, professional: danilo)

    proposal = create(:proposal, professional: danilo, project: blog)

    login_as danilo, scope: :professional

    visit project_path(blog)

    expect(page).to have_link('Visualizar Proposta', href: proposal_path(proposal))
    expect(page).to_not have_link('Enviar', href: project_proposals_path(blog))
    expect(page).to_not have_link('Ver Propostas')
  end

  it 'and view later' do
    blog = create(:project, remote: false)
    portal_escolar = create(:project)

    danilo = create(:professional)
    create(:profile, professional: danilo)

    proposal = create(:proposal, professional: danilo, project: blog,
                                 price_hour: 100)

    login_as danilo, scope: :professional
    visit project_path(blog)
    click_on 'Visualizar Proposta'

    expect(page).to have_content(proposal.justification)
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content(proposal.weekly_hour)
    expect(page).to have_button('Cancelar Proposta')
    expect(page).to_not have_content(proposal.status)
    expect(page).to_not have_content('Feedback')
  end
  it 'and view later with status accepted' do
    blog = create(:project, remote: false)
    portal_escolar = create(:project)

    danilo = create(:professional)
    create(:profile, professional: danilo)
    proposal = create(:proposal, professional: danilo, project: blog,
                                 price_hour: 100)
    proposal.accepted!
    travel_to 4.days.from_now do
      login_as danilo, scope: :professional
      visit project_path(blog)
      click_on 'Visualizar Proposta'

      expect(page).to have_content(proposal.justification)
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content(proposal.weekly_hour)
      expect(page).to have_content('Aceito')
      expect(page).to_not have_button('Cancelar Proposta')
      expect(page).to_not have_content('Feedback')
    end
  end
  it 'and view later with status refused and feedback' do
    blog = create(:project, remote: false)
    portal_escolar = create(:project)

    danilo = create(:professional)
    create(:profile, professional: danilo)
    proposal = create(:proposal, professional: danilo, project: blog,
                                 price_hour: 100)

    proposal.update!(status: 'refused', feedback: 'Optei por outro candidato')

    login_as danilo, scope: :professional
    visit project_path(blog)
    click_on 'Visualizar Proposta'

    expect(page).to have_content(proposal.justification)
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content(proposal.weekly_hour)
    expect(page).to have_content('Recusado')
    expect(page).to have_content(proposal.feedback)
  end
  it 'and can cancel with status pending' do
    danilo = create(:professional)
    create(:profile, professional: danilo)

    proposal = create(:proposal, professional: danilo)

    login_as danilo, scope: :professional
    visit proposal_path(proposal)
    click_on 'Cancelar Proposta'

    expect(page).to have_content('Proposta cancelada com sucesso')
    expect(page).to have_content('Cancelado')
    expect(page).to_not have_content('Feedback')
    expect(page).to_not have_button('Cancelar Proposta')
  end
  it 'and can cancel with status acceted and feedback present' do
    danilo = create(:professional)
    create(:profile, professional: danilo)

    proposal = create(:proposal, professional: danilo)
    proposal.update!(status: 'accepted')

    login_as danilo, scope: :professional
    visit proposal_path(proposal)
    click_on 'Cancelar Proposta'
    fill_in 'Feedback', with: 'Entrei em outro projeto'
    click_on 'Enviar'

    expect(page).to have_content('Proposta cancelada com sucesso')
    expect(page).to have_content('Cancelado')
    expect(page).to_not have_content('Feedback')
    expect(page).to_not have_button('Cancelar Proposta')
  end
  it 'and cannot cancel with status acceted and feedback ausent' do
    danilo = create(:professional)
    create(:profile, professional: danilo)

    proposal = create(:proposal, professional: danilo)
    proposal.update!(status: 'accepted')

    login_as danilo, scope: :professional
    visit proposal_path(proposal)
    click_on 'Cancelar Proposta'
    click_on 'Enviar'

    expect(page).to have_content('Não foi possível realizar essa operação')
    expect(page).to have_content('Feedback não pode ficar em branco')
    expect(page).to have_content('Aceito')
    expect(page).to have_button('Cancelar Proposta')
    expect(page).to_not have_css('h3', text: 'Feedback')
  end
end

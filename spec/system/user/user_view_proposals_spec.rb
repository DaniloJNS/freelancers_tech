# frozen_string_literal: true

require 'rails_helper'

describe 'user view proposals', js: true do
  it 'using link and not view functionalities for professionals' do
    carlos = create(:user)

    blog = create(:project, user: carlos)
    create(:proposal, project: blog)

    login_as carlos, scope: :user
    visit project_path(blog)

    expect(current_path).to eq(project_path(blog))
    expect(page).to have_link('Ver Propostas', href: project_proposals_path(blog))
    expect(page).to_not have_content('Justificativa')
    expect(page).to_not have_button('Enviar')
    expect(page).to_not have_content('Valor/hora')
    expect(page).to_not have_content('Prazo de conclusão')
    expect(page).to_not have_content('Horas por seman')
    expect(page).to_not have_link('Visualizar Proposta')
  end
  it 'successfully' do
    carlos = create(:user)
    blog = create(:project, user: carlos)

    danilo = create(:professional)
    diego = create(:professional)
    caio = create(:professional)

    create(:proposal, project: blog, professional: danilo)
    create(:proposal, project: blog, professional: diego)
    create(:proposal, professional: caio)

    login_as carlos, scope: :user
    visit project_path(blog)
    click_on 'Ver Propostas'

    expect(current_path).to eq(project_proposals_path(blog))
    expect(page).to have_content(danilo.profile.name.upcase)
    expect(page).to have_content(danilo.email)
    expect(page).to have_button('Visualizar Proposta')
    expect(page).to have_content(diego.profile.name.upcase)
    expect(page).to have_content(diego.email)
    expect(page).to_not have_content(caio.profile.name.upcase)
    expect(page).to_not have_content(caio.email)
  end
  it 'successfully wihout view proposals canceled' do
    carlos = create(:user)
    blog = create(:project, user: carlos)

    danilo = create(:professional)
    diego = create(:professional)
    caio = create(:professional)

    create(:proposal, project: blog, professional: danilo)
    create(:proposal, project: blog, professional: diego)
    create(:proposal, professional: caio, status: 'cancel',
                      feedback: 'Vou participar de outro projeto')

    login_as carlos, scope: :user
    visit project_path(blog)
    click_on 'Ver Propostas'

    expect(current_path).to eq(project_proposals_path(blog))
    expect(page).to have_content(danilo.profile.name.upcase)
    expect(page).to have_content(danilo.email)
    expect(page).to have_button('Visualizar Proposta')
    expect(page).to have_content(diego.profile.name.upcase)
    expect(page).to have_content(diego.email)
    expect(page).to_not have_content(caio.profile.name.upcase)
    expect(page).to_not have_content(caio.email)
  end
  it 'and see details' do
    carlos = create(:user)
    portal_escola = create(:project, user: carlos)

    danilo = create(:professional)
    proposal = create(:proposal, project: portal_escola, professional: danilo,
                                 price_hour: 100, weekly_hour: 20, completion_deadline: 50)

    login_as carlos, scope: :user
    visit approval_proposal_path(proposal)

    expect(page).to have_content(proposal.justification)
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content(/20/)
    expect(page).to have_content('50 dias')
    expect(page).to have_content(danilo.email)
    expect(page).to have_button('Aceitar')
    expect(page).to have_button('Recusar')
  end
  it 'see details and accepted' do
    carlos = create(:user)
    portal_escola = create(:project, user: carlos)

    danilo = create(:professional)
    proposal = create(:proposal, project: portal_escola, professional: danilo,
                                 price_hour: 100, weekly_hour: 20, completion_deadline: 50)

    login_as carlos, scope: :user
    visit approval_proposal_path(proposal)
    click_on 'Aceitar'

    expect(page).to have_content(proposal.justification)
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content(/20/)
    expect(page).to have_content('50 dias')
    expect(page).to have_content(danilo.email)
    expect(page).to have_content('aceita')
    expect(page).to have_content('Proposta aceita com sucesso')
    expect(page).to have_content('Aceito')
    expect(page).to_not have_button('Aceitar')
    expect(page).to_not have_button('Recusar')
  end
  it 'see details and refused with feedback' do
    carlos = create(:user)
    portal_escola = create(:project, user: carlos)

    danilo = create(:professional)
    proposal = create(:proposal, project: portal_escola, professional: danilo,
                                 price_hour: 100, weekly_hour: 20, completion_deadline: 50)
    login_as carlos, scope: :user
    visit approval_proposal_path(proposal)

    click_on 'Recusar'
    fill_in 'Feedback', with: 'Neste momento, optei por outra proposta'
    click_on 'Enviar'

    expect(page).to have_content('Proposta recusada com sucesso')
    expect(page).to have_content('Recusado')
    expect(page).to_not have_button('Aceitar')
    expect(page).to_not have_button('Recusar')
  end
  it 'see details and refused without feedback' do
    carlos = create(:user)
    portal_escola = create(:project, user: carlos)

    danilo = create(:professional)
    create(:proposal, project: portal_escola, professional: danilo,
                      price_hour: 100, weekly_hour: 20, completion_deadline: 50)

    login_as carlos, scope: :user
    visit project_proposals_path(portal_escola)
    click_on 'Visualizar Proposta'
    click_on 'Recusar'
    click_on 'Enviar'

    expect(page).to have_content('Feedback não deve ficar em branco')
    expect(page).to_not have_content('Recusado')
    expect(page).to have_button('Aceitar')
    expect(page).to have_button('Recusar')
  end

  it 'with status cancel' do
    carlos = create(:user)
    portal_escola = create(:project, user: carlos)

    danilo = create(:professional)
    proposal = create(:proposal, project: portal_escola, professional: danilo,
                                 price_hour: 100, weekly_hour: 20, completion_deadline:
                      50, status: 'cancel', feedback: 'Escolhi outro projeto')

    login_as carlos, scope: :user
    visit project_proposals_path(portal_escola)
    click_on 'Visualizar Proposta'

    expect(page).to have_content('Feedback')
    expect(page).to have_content(proposal.feedback)
  end
end

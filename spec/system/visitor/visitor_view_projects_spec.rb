require 'rails_helper'

describe 'visitor view projects' do
  it 'using menu' do
    visit root_path

    expect(page).to have_link('Ver Projetos', href: public_projects_path)
  end
  it 'succefully' do
    danilo = User.create!(email: 'danilo@rmotors.com.br', password: '1234567')
    marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')
    pedro = User.create!(email: 'pedro_calixto@mail.com', password: '123456')

    login_as danilo, scope: :user

    ecommerce = create(:project)
    portal_escolar = create(:project)
    tabuleiro = create(:project, status: 'closed')
    sistema_react = create(:project, status: 'finished')

    visit root_path
    click_on 'Ver Projetos'

    expect(page).to have_content(ecommerce.title)
    expect(page).to have_content(ecommerce.description)
    expect(page).to have_content(ecommerce.days_remaining)
    expect(page).to have_content(portal_escolar.title)
    expect(page).to have_content(portal_escolar.description)
    expect(page).to have_content(portal_escolar.days_remaining)
    expect(page).to_not have_content(tabuleiro.title)
    expect(page).to_not have_content(tabuleiro.description)
    expect(page).to_not have_content(tabuleiro.days_remaining)
    expect(page).to_not have_content(sistema_react.title)
    expect(page).to_not have_content(sistema_react.description)
    expect(page).to_not have_content(sistema_react.days_remaining)
  end

  it 'and theres no projects available' do
    visit root_path

    tabuleiro = create(:project, status: 'closed')
    sistema_react = create(:project, status: 'finished')

    click_on 'Ver Projetos'

    expect(page).to have_content('Ops, no momento não temos projetos abertos')
    expect(page).to have_content('Tente novamente mais tarde')
  end
end

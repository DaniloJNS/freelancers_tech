require 'rails_helper'

describe 'visitor view projects' do
  it 'using menu' do
    visit root_path

    expect(page).to have_link('Ver Projetos', href: public_projects_path)
  end
  it 'succefully' do
    danilo = User.create!(email: 'danilo@rmotors.com.br', password: '1234567')
    marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

    login_as danilo, scope: :user

    ecommerce =Project.create!(title: 'Ecommerce de carros', description: 'uma plataforma para venda, '\
                    'troca e compra de carros', deadline_submission: 3.day.from_now, remote: true,
                    max_price_per_hour: 250, user: danilo)
    portal_escolar = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                    'atividades escolares', deadline_submission: 5.day.from_now, remote: true,
                   max_price_per_hour: 150, user: marcia)
    visit root_path
    click_on "Ver Projetos"

    expect(page).to have_content(ecommerce.title)
    expect(page).to have_content(ecommerce.description)
    expect(page).to have_content(ecommerce.days_remaining) 
    expect(page).to have_content(portal_escolar.title)
    expect(page).to have_content(portal_escolar.description)
    expect(page).to have_content(portal_escolar.days_remaining)
  end

  it 'and theres no projects available' do
    visit root_path

    click_on "Ver Projetos"

    expect(page).to have_content("Ops, no momento não temos projetos abertos") 
    expect(page).to have_content("Tente novamente mais tarde") 
  end
end

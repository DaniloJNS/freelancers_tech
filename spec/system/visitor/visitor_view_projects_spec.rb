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

    Project.create!(title: 'Ecommerce de carros', description: 'uma plataforma para venda, '\
                    'troca e compra de carros', deadline_submission: '21/12/2021', remote: true,
                    max_price_per_hour: 250, user: danilo)
    Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                   'atividades escolares', deadline_submission: '10/10/2021', remote: true,
                   max_price_per_hour: 150, user: marcia)
    visit root_path
    click_on "Ver Projetos"

    expect(page).to have_content("Ecommerce de carros")
    expect(page).to have_content("uma plataforma para venda, troca e compra de carros")
    expect(page).to have_content("21/12/2021") 
    expect(page).to have_content("Portal Escolar")
    expect(page).to have_content("Um portal para gerenciamento de atividades escolares")
    expect(page).to have_content("10/10/2021")
  end

  it 'and theres no projects available' do
    visit root_path

    click_on "Ver Projetos"

    expect(page).to have_content("Ops, no momento não temos projetos abertos") 
    expect(page).to have_content("Tente novamente mais tarde") 
  end
end

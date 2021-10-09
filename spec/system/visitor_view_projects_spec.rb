require 'rails_helper'

describe 'visitor view projects' do
  it 'using menu' do
    visit root_path

    expect(page).to have_link('Ver Projetos', href: projects_path)
  end
  it 'succefully' do
    danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

    login_as danilo, scope: :user
    Project.create!(title: 'Ecommerce de carros', description: 'uma plataforma para venda, '\
                    'troca e compra de carros', deadline_submission: '21/12/2021', user: danilo)
    visit root_path
    click_on "Ver Projetos"

    expect(page).to have_content("Ecommerce de carros")
    expect(page).to have_content("uma plataforma para venda, troca e compra de carros")
    expect(page).to have_content("2021-12-21") 
  end

  it 'and theres no projects available' do
    visit root_path

    click_on "Ver Projetos"

    expect(page).to have_content("Ops, no momento não temos projetos abertos") 
    expect(page).to have_content("Tente novamente mais tarde") 
  end
end

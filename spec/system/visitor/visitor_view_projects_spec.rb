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

    ecommerce =Project.create!(title: 'Ecommerce de carros', description: 'uma plataforma para venda, '\
                               'troca e compra de carros', deadline_submission: 3.day.from_now, remote: true,
                               max_price_per_hour: 250, user: danilo)
    portal_escolar = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                    'atividades escolares', deadline_submission: 5.day.from_now, remote: true,
                   max_price_per_hour: 150, user: marcia)
    tabuleiro = Project.create!(title: 'Criar arte para jogo de tabuleiro', description: 'Desenvolvimento de jogo de '\
                                'tabuleiro, necessito de alguém para transformar minhas ideias em arte, como o tabuleiro'\
                                'do jogo e cartas', max_price_per_hour: 300, deadline_submission: 2.weeks.from_now,
                                remote: true, user: pedro, status: 'closed')
    sistema_react = Project.create!(title: 'Criar diversas telas de um sistema em React.js', description: 'Preciso de um profissional com experiência '\
                                    'em React.js para construção de diversas telas de um sistema que esta sendo reescrito',
                                    max_price_per_hour: 270, deadline_submission: 12.days.from_now, user: pedro,
                                    status: 'finished')
    visit root_path
    click_on "Ver Projetos"

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
    pedro = User.create!(email: 'pedro_calixto@mail.com', password: '123456')

    tabuleiro = Project.create!(title: 'Criar arte para jogo de tabuleiro', description: 'Desenvolvimento de jogo de '\
                                'tabuleiro, necessito de alguém para transformar minhas ideias em arte, como o tabuleiro'\
                                'do jogo e cartas', max_price_per_hour: 300, deadline_submission: 2.weeks.from_now,
                                remote: true, user: pedro, status: 'closed')
    sistema_react = Project.create!(title: 'Criar diversas telas de um sistema em React.js', description: 'Preciso de um profissional com experiência '\
                                    'em React.js para construção de diversas telas de um sistema que esta sendo reescrito',
                                    max_price_per_hour: 270, deadline_submission: 12.days.from_now, user: pedro,
                                    status: 'finished')

    click_on "Ver Projetos"

    expect(page).to have_content("Ops, no momento não temos projetos abertos") 
    expect(page).to have_content("Tente novamente mais tarde") 
  end
end

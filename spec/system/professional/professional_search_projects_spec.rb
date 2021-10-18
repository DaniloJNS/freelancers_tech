require 'rails_helper'

describe 'professional search projects' do
  it 'successfully' do
    
    carlos = User.create!(email: 'carlos@treinadev.com.br', password: '1234567')
    marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

    blog = Project.create!(title: 'Blog', description: 'Um simples blog',
                           deadline_submission: 1.day.from_now, remote: false, 
                           max_price_per_hour: 190, user: carlos)
    portal_escola = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                    'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                    max_price_per_hour: 150, user: marcia)
    danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
    Profile.create!(name: 'danilo', description: 'dev java', birth_date: '13/8/1990',
                    professional: danilo) 

    login_as danilo, scope: :professional
 
    visit public_projects_path

    find('input#search').fill_in(with: "blog")
    click_on "Pesquisar"

    expect(current_path).to eq(search_projects_path) 
    expect(page).to have_content(blog.title)
    expect(page).to have_content(blog.description)
    expect(page).to have_content(blog.days_remaining)
    expect(page).to_not have_content(portal_escola.title)
    expect(page).to_not have_content(portal_escola.description) 
    expect(page).to_not have_content(portal_escola.days_remaining)
  end
  it 'and found none' do
    carlos = User.create!(email: 'carlos@treinadev.com.br', password: '1234567')
    marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

    blog = Project.create!(title: 'Blog', description: 'Um simples blog',
                           deadline_submission: 1.day.from_now, remote: false, 
                           max_price_per_hour: 190, user: carlos)
    portal_escola = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                    'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                    max_price_per_hour: 150, user: marcia)
    danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
    Profile.create!(name: 'danilo', description: 'dev java', birth_date: '13/8/1990',
                    professional: danilo) 

    login_as danilo, scope: :professional
 
    visit public_projects_path

    find('input#search').fill_in(with: "Lespm")
    click_on "Pesquisar"
    
    expect(current_path).to eq(search_projects_path)
    expect(page).to have_content('Sua pesquisa não encontrou nenhum projeto correspondente')
  end
end

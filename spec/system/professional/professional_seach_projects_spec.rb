require 'rails_helper'

describe 'professional seach projects' do

  it 'using menu' do
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
    
    visit root_path

    expect(current_path).to eql(root_path) 
    expect(page).to have_link('Ver Projetos')
  end

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
             Profile.create!(name: 'danilo', description: 'dev java', birth_date: 
                             '13/8/1990', professional: danilo) 

    login_as danilo, scope: :professional
    
    visit public_projects_path

    expect(current_path).to eq(public_projects_path)
    
    expect(page).to have_content(blog.title) 
    expect(page).to have_content(blog.description)
    expect(page).to have_content(blog.deadline_submission)
    
    expect(page).to have_content(portal_escola.title)
    expect(page).to have_content(portal_escola.description)
    expect(page).to have_content(portal_escola.deadline_submission)

  end
  it 'successfully and view a project' do
   carlos = User.create!(email: 'carlos@treinadev.com.br', password: '1234567')
   marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

   blog = Project.create!(title: 'Blog', description: 'Um simples blog',
                          deadline_submission: 1.day.from_now, remote: false, 
                          max_price_per_hour: 190, user: carlos)

   portal_escola = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                   'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                   max_price_per_hour: 150, user: marcia)
 
    danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
             Profile.create!(name: 'danilo', description: 'dev java', birth_date: 
                             '13/8/1990', professional: danilo) 

    login_as danilo, scope: :professional
    
    visit public_projects_path
    click_on blog.title

    expect(current_path).to eq(project_path(blog)) 
    expect(page).to have_content(blog.title)
    expect(page).to have_content(blog.description)
    expect(page).to have_content(blog.deadline_submission)
    expect(page).to have_content('Não')
    expect(page).to have_content('R$ 190,00')
  end

  it 'no theres projects available' do
    danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
             Profile.create!(name: 'danilo', description: 'dev java', birth_date: 
                             '13/8/1990', professional: danilo) 

    login_as danilo, scope: :professional
    
    visit public_projects_path

    expect(page).to have_content('Ops, no momento não temos projetos abertos')
    expect(page).to have_content('Tente novamente mais tarde')
  end
end

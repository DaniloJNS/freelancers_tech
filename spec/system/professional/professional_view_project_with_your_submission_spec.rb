require 'rails_helper'

describe 'professional view projects with your submission' do
  it 'using menu' do
    danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
    Profile.create!(name: 'danilo', description: 'dev java', birth_date: '13/8/1990',
                    professional: danilo) 

    login_as danilo, scope: :professional
    
    visit root_path
    
    expect(page).to have_link('Meus Projetos', href: professional_projects_path(danilo.profile.name))
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
   proposal_blog = Proposal.create!(justification: 'Sou um gênio', price_hour: 100,
                                    weekly_hour: 20, completion_deadline: 50, 
                                    professional: danilo, project: blog)
   proposal_portal = Proposal.create!(justification: 'Sou legal', price_hour: 125,
                                      weekly_hour: 30, completion_deadline: 90, 
                                      professional: danilo, project: portal_escola)
   login_as danilo, scope: :professional
   visit professional_projects_path(danilo)

   expect(current_path).to eq(professional_projects_path(danilo))
   expect(page).to have_content(blog.title)
   expect(page).to have_content(portal_escola.title)
 end
 it 'and no available project' do
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
   visit professional_projects_path(danilo)

   expect(current_path).to eq(professional_projects_path(danilo)) 
   expect(page).to have_content('Ops, você ainda não apresentou propostas na plataforma')
   expect(page).to_not have_content(blog.title)
   expect(page).to_not have_content(portal_escola.title)
 end
end
 
 

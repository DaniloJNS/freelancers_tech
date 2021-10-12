require 'rails_helper'

describe 'user view project' do
 it 'using menu' do
   danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

   login_as danilo, scope: :user
   visit root_path

   expect(page).to have_link('Meus Projetos', href: projects_path)
   
 end 

 it 'successfully' do
   danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')
   marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

   blog = Project.create!(title: 'Blog da manu', description: 'Um simples blog',
                          deadline_submission: 1.day.from_now, remote: false, 
                         max_price_per_hour: 190, user: danilo)

   Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                   'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                 max_price_per_hour: 150, user: marcia)
   login_as danilo, scope: :user

   visit root_path
   click_on "Meus Projetos"
   
   expect(page).to have_content('Blog da manu')
   expect(page).to have_content('Um simples blog') 
   expect(page).to have_content(blog.deadline_submission)
   expect(page).to_not have_content("Portal Escolar") 
 end

 it 'and theres no avaliable projects' do
  danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

  login_as danilo, scope: :user
  visit root_path
 end
end

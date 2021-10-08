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
   blog = Project.create!(title: 'Blog da manu', description: 'Um simples blog',
                         deadline_submission: '11/12/2023')

   login_as danilo, scope: :user

   visit root_path
   click_on "Meus Projetos"
   
   expect(page).to have_content('Blog da manu')
   expect(page).to have_content('Um simples blog') 
   expect(page).to have_content('2023-12-11')
 end

 it 'and theres no avaliable projects' do
  danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

  login_as danilo, scope: :user
  visit root_path
 end
end

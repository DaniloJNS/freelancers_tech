require 'rails_helper'

describe 'professional without profile' do
  it 'try to view a project' do
   carlos = User.create!(email: 'carlos@treinadev.com.br', password: '1234567')
   marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

   blog = Project.create!(title: 'Blog', description: 'Um simples blog',
                          deadline_submission: 1.day.from_now, remote: false, 
                          max_price_per_hour: 190, user: carlos)

   portal_escola = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                   'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                   max_price_per_hour: 150, user: marcia)
 
 
    danilo = Professional.create!(email: 'danilo@tech.com.br', password: '123456')

    login_as danilo, scope: :professional
    get projects_path(blog)

    expect(response).to redirect_to(new_professional_profile_path(danilo))
  end
  it 'cannot view your project index' do

    danilo = Professional.create!(email: 'danilo@tech.com.br', password: '123456')

    login_as danilo, scope: :professional

    get professional_projects_path(danilo)

    expect(response).to redirect_to(new_professional_profile_path(danilo))
  end
end

require 'rails_helper'

describe 'professional without profile' do
  it 'view a project' do
    marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')
    portal_escolar = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                   'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                 max_price_per_hour: 150, user: marcia)

    danilo = Professional.create!(email: 'danilo@tech.com.br', password: '123456')

    login_as danilo, scope: :professional

    visit project_path(portal_escolar)
    
    expect(current_path).to eq(new_professional_profile_path(danilo))
    expect(page).to have_content("Por favor complete seu perfil antes de acessar "\
                                "a plataforma")
  end
end

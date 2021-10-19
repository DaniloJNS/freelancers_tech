require 'rails_helper'

describe 'user ends registrations' do
  it 'using button' do
    danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')
    
    blog = Project.create!(title: 'Blog da manu', description: 'Um simples blog',
                           deadline_submission: 1.day.from_now, remote: false, 
                           max_price_per_hour: 190, user: danilo)

    login_as danilo, scope: :user
    visit projects_path

    expect(page).to have_button('Encerrar Inscrições')
  end
  it 'successfully' do
    danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')
    
    blog = Project.create!(title: 'Blog da manu', description: 'Um simples blog',
                           deadline_submission: 1.day.from_now, remote: false, 
                           max_price_per_hour: 190, user: danilo)

    login_as danilo, scope: :user
    visit projects_path
    click_on "Encerrar Inscrições"
    
    expect(page).to have_content('Inscrições encerradas com sucesso')
  end
end

require 'rails_helper'

describe 'user view details' do
  it 'successfully' do
    danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

    blog = Project.create!(title: 'Blog da manu', description: 'Um simples blog',
                          deadline_submission: '11/12/2023', remote: false, 
                          max_price_per_hour: 190, user: danilo)

    login_as danilo, scope: :user

    visit root_path
    click_on 'Meus Projetos'
    click_on "Blog da manu"
    # Ver detalhes
    expect(page).to have_content("Blog da manu") 
    expect(page).to have_content("Um simples blog")
    expect(page).to have_content("11/12/2023") 
    expect(page).to have_content("Não") 
    expect(page).to have_content("R$ 190,00")
    expect(page).to have_content("danilo@treinadev.com.br")
  end
  
end

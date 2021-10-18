require 'rails_helper'

describe 'visitor log in' do
  it 'using menu for user' do
    visit root_path
    click_on "Entrar"

    expect(page).to have_link('Usuário', href: new_user_session_path) 
  end
  it 'using menu for profissional' do
    visit root_path
    click_on "Entrar"

    expect(page).to have_link('FreelancerTech', href: new_professional_session_path)
  end
  it 'successfully as user and return root path' do
    danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

    visit root_path
    click_on "Entrar"
    click_on "Usuário"

    fill_in "Email", with: "danilo@treinadev.com.br" 
    fill_in "Senha", with: "1234567"
    click_on "Enviar"
    
    expect(page).to have_content('Login efetuado com sucesso!') 
    expect(page).to have_content("#{danilo.email}") 
  end 
  it 'successfully as professional without profile' do
    danilo = Professional.create!(email: 'danilo@treinadev.com.br', password: '1234567')

    visit root_path
    click_on "FreelancerTech"

    fill_in "Email", with: danilo.email
    fill_in "Senha", with: danilo.password
    click_on "Enviar"
    

    expect(current_path).to eq(new_professional_profile_path(danilo)) 
    expect(page).to have_content('Login efetuado com sucesso!') 
    expect(page).to have_content("#{danilo.email}") 
  end
  it 'successfully as professional with profile complete and return root path' do
      carla = Professional.create!(email: 'carla@treinadev.com.br', password: '1234567')
      Profile.create!(name: carla, description: 'desenvolvedora', birth_date: '11/12/1990', 
                      professional: carla)

      visit new_professional_session_path

      fill_in "Email", with: carla.email
      fill_in "Senha", with: carla.password
      click_on "Enviar"
      
      expect(page).to have_content('Login efetuado com sucesso!') 
      expect(page).to have_content("#{carla.profile.name}") 
      expect(current_path).to eq(root_path) 
    end
end

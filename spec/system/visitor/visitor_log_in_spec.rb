require 'rails_helper'

describe 'visitor log in' do
  it 'using menu for user' do
    visit root_path
    click_on "Entrar"

    expect(page).to have_link('Sou Usuario', href: new_user_session_path) 
  end
  it 'using menu for profissional' do
    visit root_path
    click_on "Entrar"

    expect(page).to have_link('Sou FreelancerTech', href: new_professional_session_path)
  end
  it 'successfully as user and return root path' do
    danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

    visit root_path
    click_on "Entrar Sou Usuario"

    fill_in "Email", with: "danilo@treinadev.com.br" 
    fill_in "Senha", with: "1234567"
    click_on "Enviar"
    
    expect(page).to have_content('Login efetuado com sucesso!') 
    expect(page).to have_content("Logado como #{danilo.email}") 
  end 
  it 'successfully as user and return root path' do
    danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

    visit root_path
    click_on "Entrar Sou Usuario"

    fill_in "Email", with: danilo.email
    fill_in "Senha", with: danilo.password
    click_on "Enviar"
    
    expect(page).to have_content('Login efetuado com sucesso!') 
    expect(page).to have_content("Logado como #{danilo.email}") 
  end
  it 'successfully as user and return root path' do
      carla = User.create!(email: 'carla@treinadev.com.br', password: '1234567')

      visit root_path
      click_on "Entrar Sou Usuario"

      fill_in "Email", with: carla.email
      fill_in "Senha", with: carla.password
      click_on "Enviar"
      
      expect(page).to have_content('Login efetuado com sucesso!') 
      expect(page).to have_content("Logado como #{carla.email}") 
    end
end

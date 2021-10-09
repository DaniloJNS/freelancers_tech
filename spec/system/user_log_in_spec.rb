require 'rails_helper'

describe 'user log in' do
  it 'using menu' do
    visit root_path

    expect(page).to have_link('Entrar Sou Usuario', href: new_user_session_path) 
  end
  it 'successfully and return root path' do
    danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

    visit root_path
    click_on "Entrar Sou Usuario"

    fill_in "Email", with: "danilo@treinadev.com.br" 
    fill_in "Password", with: "1234567"
    click_on "Log in"
    
    expect(page).to have_content('Login efetuado com sucesso!') 
    expect(page).to have_content("Logado como #{danilo.email}") 
  end 
end

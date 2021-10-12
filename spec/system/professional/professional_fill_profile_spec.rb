require 'rails_helper'

describe 'professional fill profile' do
  it 'later sing up' do

    visit  new_professional_registration_path

    fill_in "Email", with: "danilo@tech.com.br"
    fill_in "Senha", with: "1234567"
    fill_in "Confirmar senha", with: "1234567"
    
    within 'form' do
     click_on 'Enviar'
    end
    expect(current_path).to_not eq(root_path)
  end
  it 'later login' do
    danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")

    visit new_professional_session_path

    fill_in "Email", with: "danilo@tech.com.br"
    fill_in "Senha", with: "1234567"
    within 'form' do
     click_on 'Enviar'
    end

    expect(current_path).to_not eq(root_path) 
  end
  it 'successfully' do
    danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
  
    login_as danilo, scope: :professional
    
    visit new_professional_profile_path(danilo)

    fill_in "Nome", with: "Danilo da Silva"
    fill_in "Data de Nascimento", with: "10/10/1980"
    fill_in "Descrição", with: "Entusiasta de cloud computer"
    click_on "Enviar"

    expect(current_path).to eq(root_path) 
    expect(page).to have_content('Seu perfil está completo!')
  end
  it 'with fields empty' do
    danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")

    login_as danilo, scope: :professional

    visit new_professional_profile_path(danilo)
    click_on "Enviar"

    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Data de Nascimento não pode ficar em branco')
  end
end

require 'rails_helper'

describe 'vistor sign up' do
  it 'using menu as professional' do
    visit root_path
    click_on "Inscreva-se"

    expect(page).to have_link('Novo FreelancerTech', href: new_professional_registration_path)
  end
  it 'using menu as user' do
    visit root_path
    click_on "Inscreva-se"

    expect(page).to have_link('Novo Usuário', href: new_user_registration_path)
  end
  it 'successfully as professional' do

    visit new_professional_registration_path

    fill_in "Email", with: "carlos@tech.com.br"
    fill_in "Senha", with: 1234567
    fill_in "Confirmar senha", with: "1234567"

    click_on "Enviar"

    expect(page).to have_content('Inscrição efetuada com sucesso. Se não foi autorizado, a confirmação será enviada por e-mail.')
  end
  it 'successfully as user' do

    visit new_user_registration_path

    fill_in "Email", with: "carlos@tech.com.br"
    fill_in "Senha", with: 1234567
    fill_in "Confirmar senha", with: "1234567"

    click_on "Enviar"

    expect(page).to have_content('Inscrição efetuada com sucesso. Se não foi autorizado, a confirmação será enviada por e-mail.')
  end
end

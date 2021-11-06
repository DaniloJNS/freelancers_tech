# frozen_string_literal: true

require 'rails_helper'

describe 'visitor log in' do
  it 'using menu for user' do
    visit root_path
    click_on 'Entrar'

    expect(page).to have_link('Usuário', href: new_user_session_path)
  end
  it 'using menu for profissional' do
    visit root_path
    click_on 'Entrar'

    expect(page).to have_link('FreelancerTech', href: new_professional_session_path)
  end
  it 'successfully as user and return root path' do
    danilo = create(:user)

    visit root_path
    click_on 'Entrar'
    click_on 'Usuário'

    fill_in 'Email', with: danilo.email
    fill_in 'Senha', with: danilo.password
    click_on 'Enviar'

    expect(page).to have_content('Login efetuado com sucesso!')
    expect(page).to have_content(danilo.email.to_s)
  end
  it 'successfully as professional without profile' do
    danilo = create(:professional)

    visit root_path
    click_on 'FreelancerTech'

    fill_in 'Email', with: danilo.email
    fill_in 'Senha', with: danilo.password
    click_on 'Enviar'

    expect(current_path).to eq(new_professional_profile_path(danilo))
    expect(page).to have_content('Por favor complete seu perfil antes de acessar a plata'\
                                 'forma')
    expect(page).to have_content(danilo.email.to_s)
  end
  it 'successfully as professional with profile complete and return root path' do
    carla = create(:professional)
    create(:profile, professional: carla)

    visit new_professional_session_path

    fill_in 'Email', with: carla.email
    fill_in 'Senha', with: carla.password
    click_on 'Enviar'

    expect(page).to have_content('Login efetuado com sucesso!')
    expect(page).to have_content(carla.profile.name.to_s)
    expect(current_path).to eq(root_path)
  end
end

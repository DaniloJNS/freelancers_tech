# frozen_string_literal: true

require 'rails_helper'

describe 'professional fill profile' do
  it 'later sing up' do
    visit new_professional_registration_path

    fill_in 'Email', with: 'danilo@tech.com.br'
    fill_in 'Senha', with: '1234567'
    fill_in 'Confirmar senha', with: '1234567'

    within 'form' do
      click_on 'Enviar'
    end
    expect(current_path).to_not eq(root_path)
  end
  it 'later login' do
    danilo = Professional.create!(email: 'danilo@tech.com.br', password: '1234567')

    visit new_professional_session_path

    fill_in 'Email', with: 'danilo@tech.com.br'
    fill_in 'Senha', with: '1234567'
    within 'form' do
      click_on 'Enviar'
    end

    expect(current_path).to eq(new_professional_profile_path(danilo))
  end
  it 'successfully' do
    danilo = create(:professional)

    login_as danilo, scope: :professional

    visit new_professional_profile_path(danilo)

    fill_in 'Nome', with: 'Danilo da Silva'
    fill_in 'Data de Nascimento', with: '10/10/1980'
    fill_in 'Descrição', with: 'Entusiasta de cloud computer'
    click_on 'Enviar'

    expect(current_path).to_not eq(root_path)
    expect(page).to have_content('Seu perfil está completo!')
  end
  it 'with fields empty' do
    danilo = create(:professional)

    login_as danilo, scope: :professional

    visit new_professional_profile_path(danilo)
    click_on 'Enviar'

    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Data de Nascimento não pode ficar em branco')
  end
  it 'successfully with formation' do
    maicon = create(:professional)
    Profile.create!(name: 'maicon', description: 'Dev back-end laravel and django',
                    birth_date: '11/4/1990', professional: maicon)

    login_as maicon, scope: :professional

    visit new_profile_formation_path(maicon.profile)

    fill_in 'Universidade', with: 'UFMA'
    check 'Concluído'
    fill_in 'Data de início', with: 10.years.ago
    fill_in 'Data de conclusão', with: 5.years.ago
    click_on 'Enviar'

    expect(page).to have_content('Formação registrada com sucesso')
    # expect(current_path).to eq(new_profile_experience_path(maicon.profile))
  end
  it 'successfully with formation empty' do
    maicon = create(:professional)
    create(:profile, professional: maicon)

    login_as maicon, scope: :professional

    visit new_profile_formation_path(maicon.profile)

    click_on 'Enviar'

    expect(page).to have_content('Universidade não pode ficar em branco')
    expect(page).to have_content('Data de Início não pode ficar em branco')
    expect(page).to have_content('Data de Conclusão não pode ficar em branco')
  end
  it 'successfully and skip formation' do
    maicon = create(:professional)
    create(:profile, professional: maicon)

    login_as maicon, scope: :professional
    visit new_profile_formation_path(maicon.profile)

    click_on 'Pular'

    expect(current_path).to eq(root_path)
  end
  it 'successfully with experience' do
    maicon = create(:professional)
    create(:profile, professional: maicon)

    login_as maicon, scope: :professional
    visit new_profile_experience_path(maicon.profile)

    fill_in 'Empresa', with: 'The Coca-Cola Company'
    fill_in 'Cargo', with: 'Gerente de TI'
    fill_in 'Descrição', with: 'Trabalhei liderando uma equipe de 100 pessoas'
    fill_in 'Data de Início', with: '10/08/2008'
    fill_in 'Data de Termínio', with: '15/12/2017'
    click_on 'Enviar'

    expect(page).to have_content('Experiência registrada com sucesso')
  end
  it 'successfully with experience empty' do
    maicon = create(:professional)
    create(:profile, professional: maicon)

    login_as maicon, scope: :professional
    visit new_profile_experience_path(maicon.profile)

    click_on 'Enviar'
    expect(page).to have_content('Empresa não pode ficar em branco')
    expect(page).to have_content('Cargo não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Data de Início não pode ficar em branco')
  end
end

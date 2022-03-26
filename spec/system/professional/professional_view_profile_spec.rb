# frozen_string_literal: true

require 'rails_helper'

describe 'professional view profile' do
  it 'using link' do
    danilo = create(:professional)
    create(:profile, name: 'danilo', professional: danilo)

    login_as danilo, scope: :professional

    visit root_path

    click_on 'danilo'

    expect(page).to have_link('Ver Perfil', href: profile_path(danilo.profile.id))
  end

  it 'sucessfuly' do
    danilo = create(:professional)
    create(:profile, name: 'danilo', description: 'Entusiasta de cloud computer',
                     birth_date: '13/02/1992', professional: danilo)

    login_as danilo, scope: :professional

    visit root_path

    click_on 'danilo'
    click_on 'Ver Perfil'

    expect(page).to have_content('danilo')
    expect(page).to have_content('Entusiasta de cloud computer')
    expect(page).to have_content(danilo.profile.age)
    expect(page).to have_content('Masculino')
  end
end

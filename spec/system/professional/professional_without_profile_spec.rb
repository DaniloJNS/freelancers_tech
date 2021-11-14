# frozen_string_literal: true

require 'rails_helper'

describe 'professional without profile' do
  it 'view a project' do
    create(:project, remote: false)
    portal_escolar = create(:project)

    danilo = create(:professional)

    login_as danilo, scope: :professional

    visit project_path(portal_escolar)

    expect(current_path).to eq(new_professional_profile_path(danilo))
    expect(page).to have_content('Por favor complete seu perfil antes de'\
                                 ' acessar a plataforma')
  end
end

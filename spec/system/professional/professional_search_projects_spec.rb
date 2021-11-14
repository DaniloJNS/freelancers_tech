# frozen_string_literal: true

require 'rails_helper'

describe 'professional search projects' do
  it 'successfully' do
    blog = create(:project)
    portal_escola = create(:project, status: 'closed')
    tabuleiro = create(:project)
    sistema_react = create(:project)

    danilo = create(:professional)
    create(:profile, professional: danilo)

    login_as danilo, scope: :professional

    visit public_projects_path

    find('input#search').fill_in(with: blog.title)
    click_on 'Pesquisar'

    expect(current_path).to eq(search_projects_path)
    expect(page).to have_content(blog.title)
    expect(page).to have_content(blog.description)
    expect(page).to have_content("#{blog.days_remaining} dias")
    expect(page).to_not have_content('Sua pesquisa não encontrou nenhum projeto correspondente')
    expect(page).to_not have_content(portal_escola.title)
    expect(page).to_not have_content(portal_escola.description)
    expect(page).to_not have_content(tabuleiro.title)
    expect(page).to_not have_content(tabuleiro.description)
    expect(page).to_not have_content(sistema_react.title)
    expect(page).to_not have_content(sistema_react.description)
  end
  it 'and found none' do
    create(:project)
    create(:project, status: 'closed')
    create(:project)
    create(:project)

    danilo = create(:professional)
    create(:profile, professional: danilo)

    login_as danilo, scope: :professional

    visit public_projects_path

    find('input#search').fill_in(with: 'Lespm')
    click_on 'Pesquisar'

    expect(current_path).to eq(search_projects_path)
    expect(page).to have_content('Sua pesquisa não encontrou nenhum projeto correspondente')
  end
  it 'dont return project with status closed' do
    portal_escola = create(:project, title: 'Portal Escolar', status: 'closed')

    danilo = create(:professional)
    create(:profile, professional: danilo)

    login_as danilo, scope: :professional

    visit public_projects_path

    find('input#search').fill_in(with: portal_escola.title)
    click_on 'Pesquisar'

    expect(page).to_not have_content(portal_escola.title)
    expect(page).to_not have_content(portal_escola.description)
  end
  it 'dont return project with status finished' do
    portal_escola = create(:project, status: 'finished')

    danilo = create(:professional)
    create(:profile, professional: danilo)

    login_as danilo, scope: :professional

    visit public_projects_path

    find('input#search').fill_in(with: portal_escola.title)
    click_on 'Pesquisar'

    expect(page).to_not have_content(portal_escola.title)
    expect(page).to_not have_content(portal_escola.description)
  end
end

require 'rails_helper'

describe 'professional view projects' do
  it 'using menu' do
    danilo = create(:professional)
    create(:profile, professional: danilo)

    login_as danilo, scope: :professional

    visit root_path

    expect(current_path).to eql(root_path)
    expect(page).to have_link('Ver Projetos', href: public_projects_path)
  end

  it 'successfully' do
    blog = create(:project)
    portal_escola = create(:project)

    danilo = create(:professional)
    create(:profile, professional: danilo)

    login_as danilo, scope: :professional

    visit public_projects_path

    expect(current_path).to eq(public_projects_path)

    expect(page).to have_content(blog.title)
    expect(page).to have_content(blog.description)
    expect(page).to have_content(blog.days_remaining)

    expect(page).to have_content(portal_escola.title)
    expect(page).to have_content(portal_escola.description)
    expect(page).to have_content(portal_escola.days_remaining)
  end
  it 'successfully and view a project' do
    blog = create(:project, remote: false)
    portal_escola = create(:project)

    danilo = create(:professional)
    create(:profile, professional: danilo)

    login_as danilo, scope: :professional

    visit public_projects_path
    click_on blog.title

    expect(current_path).to eq(project_path(blog))
    expect(page).to have_content(blog.title)
    expect(page).to have_content(blog.description)
    expect(page).to have_content(blog.deadline_submission)
    expect(page).to have_content('Não')
    expect(page).to have_content(blog.format_max_price_per_hour)
    expect(page).to_not have_link('Ver Propostas')
  end

  it 'no theres projects available' do
    danilo = create(:professional)
    create(:profile, professional: danilo)

    login_as danilo, scope: :professional

    visit public_projects_path

    expect(page).to have_content('Ops, no momento não temos projetos abertos')
    expect(page).to have_content('Tente novamente mais tarde')
  end
end

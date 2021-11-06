require 'rails_helper'

describe 'user view project' do
  it 'using menu' do
    user = create(:user)

    login_as user, scope: :user
    visit root_path

    expect(page).to have_link('Meus Projetos', href: projects_path)
  end

  it 'successfully' do
    users = create_list(:user, 2)

    blog = create(:project, title: 'Blog da manu', description: 'Um simples blog', user: users.first,
                            deadline_submission: 1.week.from_now)

    portal_escolar = create(:project, title: 'Portal Escolar', description: 'Um portal para gerenciamento de'\
                                                                            'atividades escolares')

    login_as users.first, scope: :user

    visit root_path
    click_on 'Meus Projetos'

    expect(page).to have_content(blog.title)
    expect(page).to have_content(blog.description)
    expect(page).to have_content(/7/)
    expect(page).to_not have_content(portal_escolar.title)
    expect(page).to_not have_content(portal_escolar.description)
  end

  it 'and theres no avaliable projects' do
    danilo = create(:user)
    marcia = create(:user)

    portal_escolar =  create(:project, user: marcia)

    login_as danilo, scope: :user

    visit root_path
    click_on 'Meus Projetos'

    expect(current_path).to eq(projects_path)
    expect(page).to have_content('Ops, você ainda não cadastrou projetos na plataforma')
    expect(page).to have_content('Cadastre seu primeiro projeto agora')
    expect(page).to have_link('Novo Projeto')
    expect(page).to_not have_content(portal_escolar.title)
  end
  it 'and details' do
    danilo = create(:user, email: 'danilo@treinadev.com.br')

    blog = create(:project, title: 'Blog da manu', description: 'Um simples blog',
                            deadline_submission: '11/12/2023', remote: false,
                            max_price_per_hour: 190, user: danilo)

    login_as danilo, scope: :user

    visit root_path
    click_on 'Meus Projetos'
    click_on 'Blog da manu'

    expect(page).to have_content('Blog da manu')
    expect(page).to have_content('Um simples blog')
    expect(page).to have_content('11/12/2023')
    expect(page).to have_content('Não')
    expect(page).to have_content('R$ 190,00')
    expect(page).to have_content('danilo@treinadev.com.br')
  end
end

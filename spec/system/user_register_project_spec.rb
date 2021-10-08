require 'rails_helper'

describe 'user register project' do
  it 'using menu' do
    danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

    login_as danilo, scope: :user
    visit root_path

    expect(page).to have_link('Novo Projeto', href: new_project_path) 
  end

  it 'successfully' do
    danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

    login_as danilo, scope: :user
    visit root_path
    click_on 'Novo Projeto'

    fill_in "Título", with: 'Pet Shop Mobile'
    fill_in "Descrição", with: 'Uma aplicativo android para venda de produtos para pets'
    fill_in 'Receber propostas até:', with: "14/04/22"
    click_on 'Enviar'


    expect(page).to have_content('Pet Shop Mobile')
    expect(page).to have_content('Uma aplicativo android para venda de produtos para pets')
  end
end

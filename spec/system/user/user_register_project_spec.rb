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
    visit new_project_path

    fill_in "Título", with: 'Pet Shop Mobile'
    fill_in "Descrição", with: 'Uma aplicativo android para venda de produtos para pets'
    fill_in "Custo máximo por hora", with: 200
    fill_in 'Receber propostas até:', with: 1.week.from_now
    check "remoto"
    click_on 'Enviar'

    
    expect(page).to have_content('Pet Shop Mobile')
    expect(page).to have_content('Uma aplicativo android para venda de produtos para pets')
    expect(page).to have_content("R$ 200,00") 
    expect(page).to have_content(1.week.from_now.to_date) 
    expect(page).to have_content("Sim") 
  end
  it 'with fields empty' do
    danilo = User.create!(email: 'danilo@treinadev.com.br', password: '1234567')

    login_as danilo, scope: :user
    visit new_project_path

    click_on 'Enviar'

    expect(page).to have_content("Título não pode ficar em branco")
    expect(page).to have_content("Descrição não pode ficar em branco")
    expect(page).to have_content("Preço máximo por hora não pode ficar em branco")
    expect(page).to have_content("Prazo para submissão não pode ficar em branco")
  end
end

require 'rails_helper'

describe 'visitor view projects' do

  it 'succefully' do
    Project.create!(title: 'Ecommerce de carros', description: 'uma plataforma para venda, troca e comparar de carros', deadline_submission: '11/12/2021')
    visit root_path
    click_on "Ver Projetos"

    expect(page).to have_content("Ecommerce de carros")
    expect(page).to have_content("uma plataforma para venda, troca e comparar de carros")
  end
end

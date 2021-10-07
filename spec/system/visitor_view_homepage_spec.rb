require 'rails_helper'

describe 'visitor view home page' do

  it 'succefully' do
    visit root_path

    expect(page).to have_content("Bem-vindo ao freelancers tech") 
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe 'visitor view home page' do
  it 'succefully' do
    visit root_path

    expect(page).to have_content('FreelancersTECH')
  end
end

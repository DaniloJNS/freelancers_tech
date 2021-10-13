require 'rails_helper'

describe 'professional authentication' do

  it 'cannot create profile without login' do
    post professional_profiles_path(professional_id: 1)

    expect(response).to redirect_to(new_professional_session_path)
  end
  it 'cannot open profile form unless authenticated' do
    get new_professional_profile_path(professional_id: 1)

    expect(response).to redirect_to(new_professional_session_path)
  end
end

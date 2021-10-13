require 'rails_helper'

describe 'user authentication' do
  it 'cannot create project without login' do
    post projects_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'cannot open new project form unless authenticated' do
    get new_project_path

    expect(response).to redirect_to(new_user_session_path)
  end
  it 'cannot open index project view unless authenticated' do
    get projects_path

    expect(response).to redirect_to(new_user_session_path)
  end
  # TODO Routes for propostas
end

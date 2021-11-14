# frozen_string_literal: true

require 'rails_helper'

describe 'Project API' do
  context 'get /api/v1/projects' do
    it 'return all projects' do
      create(:project, title: 'Blog')
      create(:project, title: 'Site')

      get '/api/v1/projects'

      expect(response).to have_http_status(200)
      expect(response.body).to include('Blog')
      expect(response.body).to include('Site')
    end
  end
  context 'get /api/v1/project/:id' do
    it 'should be return a project' do
      project = create(:project, title: 'blog')

      get "/api/v1/projects/#{project.id}"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      expect(parsed_body[:title]).to eq('blog')
      expect(parsed_body[:remote]).to be true
    end
  end
end

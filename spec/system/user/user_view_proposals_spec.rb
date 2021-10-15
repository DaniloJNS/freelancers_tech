require 'rails_helper'

describe 'user view proposals' do
  it 'using link' do
   carlos = User.create!(email: 'carlos@treinadev.com.br', password: '1234567')
   marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

   blog = Project.create!(title: 'Blog', description: 'Um simples blog',
                          deadline_submission: 1.day.from_now, remote: false, 
                          max_price_per_hour: 190, user: carlos)

   portal_escola = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                   'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                   max_price_per_hour: 150, user: marcia)
 
   danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
   Profile.create!(name: 'danilo', description: 'dev java', birth_date: '13/8/1990',
                   professional: danilo) 

    proposal_portal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                       completion_deadline: 50, professional: danilo, project: blog)
    login_as carlos, scope: :user
    visit project_path(blog)
    
    expect(current_path).to eq(project_path(blog)) 
    expect(page).to have_link('Ver Propostas', href: project_proposals_path(blog))
  end
  it 'successfully' do
   carlos = User.create!(email: 'carlos@treinadev.com.br', password: '1234567')
   marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

   blog = Project.create!(title: 'Blog', description: 'Um simples blog',
                          deadline_submission: 1.day.from_now, remote: false, 
                          max_price_per_hour: 190, user: carlos)

   portal_escola = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                   'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                   max_price_per_hour: 150, user: marcia)
 
   danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
   Profile.create!(name: 'danilo', description: 'dev java', birth_date: '13/8/1990',
                   professional: danilo) 

    proposal_portal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                       completion_deadline: 50, professional: danilo, project: blog)
    login_as carlos, scope: :user
    visit project_path(blog)
    click_on "Ver Propostas"

    expect(current_path).to eq(project_proposals_path(blog)) 
    expect(page).to have_content(danilo.profile.name)
    expect(page).to have_content(danilo.email)
    expect(page).to have_link('Visualizar Proposta', href: proposal_path(proposal_portal))
  end

  it 'and see details' do
   carlos = User.create!(email: 'carlos@treinadev.com.br', password: '1234567')
   marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

   blog = Project.create!(title: 'Blog', description: 'Um simples blog',
                          deadline_submission: 1.day.from_now, remote: false, 
                          max_price_per_hour: 190, user: carlos)

   portal_escola = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                   'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                   max_price_per_hour: 150, user: marcia)
 
   danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
   Profile.create!(name: 'danilo', description: 'dev java', birth_date: '13/8/1990',
                   professional: danilo) 

    proposal_portal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                       completion_deadline: 50, professional: danilo, project: blog)
    login_as carlos, scope: :user
    visit proposal_path(proposal_portal)
    
    expect(page).to have_content(proposal_portal.justification)
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content(/20/)
    expect(page).to have_content('50 dias')
    expect(page).to have_content(danilo.profile.name)
    expect(page).to have_content(danilo.email)
    expect(page).to have_button('Aceitar')
    expect(page).to have_button('Recusar')
  end
  it 'see details and accepted' do
   carlos = User.create!(email: 'carlos@treinadev.com.br', password: '1234567')
   marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

   blog = Project.create!(title: 'Blog', description: 'Um simples blog',
                          deadline_submission: 1.day.from_now, remote: false, 
                          max_price_per_hour: 190, user: carlos)

   portal_escola = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                   'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                   max_price_per_hour: 150, user: marcia)
 
   danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
   Profile.create!(name: 'danilo', description: 'dev java', birth_date: '13/8/1990',
                   professional: danilo) 

   proposal_portal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                      completion_deadline: 50, professional: danilo, project: blog)
   login_as carlos, scope: :user
   visit proposal_path(proposal_portal)
   click_on "Aceitar" 

   expect(page).to have_content('Proposta aceita com sucesso')
   expect(page).to have_content('Aceito')
   expect(page).to_not have_button('Aceitar')
   expect(page).to_not have_button('Recusar')

  end
  it 'see details and refused' do
   carlos = User.create!(email: 'carlos@treinadev.com.br', password: '1234567')
   marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

   blog = Project.create!(title: 'Blog', description: 'Um simples blog',
                          deadline_submission: 1.day.from_now, remote: false, 
                          max_price_per_hour: 190, user: carlos)

   portal_escola = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                   'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                   max_price_per_hour: 150, user: marcia)
 
   danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
   Profile.create!(name: 'danilo', description: 'dev java', birth_date: '13/8/1990',
                   professional: danilo) 

   proposal_portal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                      completion_deadline: 50, professional: danilo, project: blog)
   login_as carlos, scope: :user
   visit proposal_path(proposal_portal)
   click_on "Recusar" 

   expect(page).to have_content('Proposta aceita com sucesso')
   expect(page).to have_content('Recusado')
   expect(page).to_not have_button('Aceitar')
   expect(page).to_not have_button('Recusar')
  end
end

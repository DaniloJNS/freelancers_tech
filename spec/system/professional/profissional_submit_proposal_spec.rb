require 'rails_helper'

describe 'profissional submit proposal' do
  include ActiveSupport::Testing::TimeHelpers
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

   login_as danilo, scope: :professional
    
   visit project_path(blog)

   fill_in "Justificativa", with: "Sou um gênio"
   fill_in "Valor/Hora", with: "100"
   fill_in "Horas por semana", with: "20"
   fill_in "Prazo de conclusão", with: 50
   click_on "Enviar"
    
   expect(current_path).to_not eq(project_path(blog)) 
   expect(page).to have_content('Proposta enviada com sucesso!')
   expect(page).to have_content('Sou um gênio')
   expect(page).to have_content('R$ 100,00')
   expect(page).to have_content(/20/)
   expect(page).to have_content(/50/)
   expect(page).to have_content(danilo.profile.name)
   expect(page).to have_content(danilo.email)
 end
  #TODO: Um usuario não pode fazer mais de uma proposta
 it 'with fields empty' do
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

   login_as danilo, scope: :professional
    
   visit project_path(blog)
   click_on "Enviar"
  
   expect(page).to have_content('Justificativa não pode ficar em branco')
   expect(page).to have_content('Preço por hora não pode ficar em branco')
   expect(page).to have_content('Horas por semana não pode ficar em branco')
   expect(page).to have_content('Prazo de conclusão não pode ficar em branco')
 end
 it 'two times in same projeto' do
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
   proposal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                              completion_deadline: 50, professional: danilo, project: blog)

   login_as danilo, scope: :professional
    
   visit project_path(blog)
   
   expect(page).to have_link("Visualizar Proposta", href: proposal_path(proposal)) 
   expect(page).to_not have_link('Enviar', href: project_proposals_path(blog))
   expect(page).to_not have_link('Ver Propostas')
 end

 it 'and view later' do
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
  proposal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                              completion_deadline: 50, professional: danilo, project: blog)

  login_as danilo, scope: :professional
  visit project_path(blog)
  click_on "Visualizar Proposta"
  
  expect(page).to have_content(proposal.justification)
  expect(page).to have_content("R$ 100,00")
  expect(page).to have_content(proposal.weekly_hour)
  expect(page).to have_button('Cancelar Proposta')
  expect(page).to_not have_content(proposal.status)
  expect(page).to_not have_content('Feedback')
 end
 it 'and view later with status accepted' do
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
  proposal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                              completion_deadline: 50, professional: danilo, project: blog)
  proposal.accepted!
  travel_to 4.day.from_now do
    login_as danilo, scope: :professional
    visit project_path(blog)
    click_on "Visualizar Proposta"
    
    expect(page).to have_content(proposal.justification)
    expect(page).to have_content("R$ 100,00")
    expect(page).to have_content(proposal.weekly_hour)
    expect(page).to have_content("Aceito")
    expect(page).to_not have_button("Cancelar Proposta")
    expect(page).to_not have_content('Feedback')
  end
 end
 it 'and view later with status refused and feedback' do
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
  proposal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                              completion_deadline: 50, professional: danilo, project: blog)
  proposal.update!(status: "refused", feedback: "Optei por outro candidato")

  login_as danilo, scope: :professional
  visit project_path(blog)
  click_on "Visualizar Proposta"

  expect(page).to have_content(proposal.justification)
  expect(page).to have_content("R$ 100,00")
  expect(page).to have_content(proposal.weekly_hour)
  expect(page).to have_content("Recusado")
  expect(page).to have_content(proposal.feedback)
 end
 it 'and can cancel with status pending' do
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
  proposal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                              completion_deadline: 50, professional: danilo, project: blog)

  login_as danilo, scope: :professional
  visit proposal_path(proposal)
  click_on "Cancelar Proposta"

  expect(page).to have_content('Proposta cancelada com sucesso')
  expect(page).to have_content('Cancelado')
  expect(page).to_not have_content('Feedback')
  expect(page).to_not have_button('Cancelar Proposta')
 end
 it 'and can cancel with status acceted and feedback present' do
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
  proposal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                              completion_deadline: 50, professional: danilo, project: blog)
  proposal.update!(status: "accepted")

  login_as danilo, scope: :professional
  visit proposal_path(proposal)
  click_on "Cancelar Proposta"
  fill_in "Feedback", with: "Entrei em outro projeto"
  click_on "Enviar"
  
  expect(page).to have_content('Proposta cancelada com sucesso')
  expect(page).to have_content('Cancelado')
  expect(page).to_not have_content('Feedback')
  expect(page).to_not have_button('Cancelar Proposta')
 end
  it 'and cannot cancel with status acceted and feedback ausent' do
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
   proposal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                               completion_deadline: 50, professional: danilo, project: blog)
   proposal.update!(status: "accepted")

   login_as danilo, scope: :professional
   visit proposal_path(proposal)
   click_on "Cancelar Proposta"
   click_on "Enviar"
   
   expect(page).to have_content('Não foi possível realizar essa operação')
   expect(page).to have_content('Feedback não pode ficar em branco')
   expect(page).to have_content('Aceito')
   expect(page).to have_button('Cancelar Proposta')
   expect(page).to_not have_css('h3', text: 'Feedback')
  end
end

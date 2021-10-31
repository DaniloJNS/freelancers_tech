require 'rails_helper'

describe 'user view proposals', js: true do
  it 'using link and not view functionalities for professionals' do
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
    expect(page).to_not have_content('Justificativa')
    expect(page).to_not have_button('Enviar')
    expect(page).to_not have_content('Valor/hora')
    expect(page).to_not have_content('Prazo de conclusão')
    expect(page).to_not have_content('Horas por seman')
    expect(page).to_not have_link('Visualizar Proposta')
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
    caio =   Professional.create!(email: 'caio_comp@mail.com', password: '1234567')
    diego =  Professional.create!(email: 'diego_comp@mail.com', password: '1234567')
             Profile.create!(name: 'danilo', description: 'dev java', 
                             birth_date: '13/8/1990', professional: danilo) 
             Profile.create!(name: 'caio', description: 'Dev front-end react',
                             birth_date: '11/4/1990', professional: caio)
             Profile.create!(name: 'diego', description: 'Dev front-end vue js',
                             birth_date: '11/4/1990', professional: diego)

    proposal_portal =    Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                          completion_deadline: 50, professional: danilo, project: blog)
                         Proposal.create!(justification: "tenho habilidades para esse projeto", price_hour: 100, weekly_hour: 30,
                                          completion_deadline: 25, professional: caio, project: portal_escola)
     proposal_portal_2 = Proposal.create!(justification: 'tenho habilidades para esse projeto', price_hour: 100, weekly_hour: 30, 
                                          completion_deadline: 30, professional: diego, project: blog)

    login_as carlos, scope: :user
    visit project_path(blog)
    click_on "Ver Propostas"

    expect(current_path).to eq(project_proposals_path(blog)) 
    expect(page).to have_content(danilo.profile.name.upcase)
    expect(page).to have_content(danilo.email)
    expect(page).to have_button('Visualizar Proposta')
    expect(page).to have_content(diego.profile.name)
    expect(page).to have_content(diego.email)
    expect(page).to_not have_content(caio.profile.name)
    expect(page).to_not have_content(caio.email)
  end
  it 'successfully wihout view proposals canceled' do
    carlos = User.create!(email: 'carlos@treinadev.com.br', password: '1234567')
    marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

    blog = Project.create!(title: 'Blog', description: 'Um simples blog',
                           deadline_submission: 1.day.from_now, remote: false, 
                           max_price_per_hour: 190, user: carlos)

    portal_escola = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                    'atividades escolares', deadline_submission: 3.day.from_now, remote: true,
                     max_price_per_hour: 150, user: marcia)
 
    danilo = Professional.create!(email: "danilo@tech.com.br", password: "1234567")
    caio =   Professional.create!(email: 'caio_comp@mail.com', password: '1234567')
    diego =  Professional.create!(email: 'diego_comp@mail.com', password: '1234567')
             Profile.create!(name: 'danilo', description: 'dev java', 
                             birth_date: '13/8/1990', professional: danilo) 
             Profile.create!(name: 'caio', description: 'Dev front-end react',
                             birth_date: '11/4/1990', professional: caio)
             Profile.create!(name: 'diego', description: 'Dev front-end vue js',
                             birth_date: '11/4/1990', professional: diego)

    proposal_portal =    Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                          completion_deadline: 50, professional: danilo, project: blog)
                         Proposal.create!(justification: "tenho habilidades para esse projeto", price_hour: 100, weekly_hour: 30,
                                          completion_deadline: 25, professional: caio, project: blog, status: "cancel")
    proposal_portal_2 =  Proposal.create!(justification: 'tenho habilidades para esse projeto', price_hour: 100, weekly_hour: 30, 
                                          completion_deadline: 30, professional: diego, project: blog)

    login_as carlos, scope: :user
    visit project_path(blog)
    click_on "Ver Propostas"

    expect(current_path).to eq(project_proposals_path(blog)) 
    expect(page).to have_content(danilo.profile.name)
    expect(page).to have_content(danilo.email)
    expect(page).to have_button('Visualizar Proposta')
    expect(page).to have_content(diego.profile.name)
    expect(page).to have_content(diego.email)
    expect(page).to_not have_content(caio.profile.name)
    expect(page).to_not have_content(caio.email)
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
      visit approval_proposal_path(proposal_portal)
      
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
     visit approval_proposal_path(proposal_portal)
     click_on "Aceitar" 

     expect(page).to have_content(proposal_portal.justification)
     expect(page).to have_content('R$ 100,00')
     expect(page).to have_content(/20/)
     expect(page).to have_content('50 dias')
     expect(page).to have_content(danilo.profile.name)
     expect(page).to have_content(danilo.email)
     expect(page).to have_content("aceita")
     expect(page).to have_content('Proposta aceita com sucesso')
     expect(page).to have_content('Aceito')
     expect(page).to_not have_button('Aceitar')
     expect(page).to_not have_button('Recusar')

    end
    it 'see details and refused with feedback' do
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
     visit approval_proposal_path(proposal_portal)

     click_on "Recusar" 
     fill_in "Feedback", with: "Neste momento, optei por outra proposta"
     click_on "Enviar"

     expect(page).to have_content('Proposta recusada com sucesso')
     expect(page).to have_content('Recusado')
     expect(page).to_not have_button('Aceitar')
     expect(page).to_not have_button('Recusar')
  end
    it 'see details and refused without feedback' do
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
     visit project_proposals_path(blog)
     click_on "Visualizar Proposta"
     click_on "Recusar"
     click_on "Enviar"
     
     expect(page).to have_content('Feedback não deve ficar em branco')
     expect(page).to_not have_content('Recusado')
     expect(page).to have_button('Aceitar')
     expect(page).to have_button('Recusar')
    end

    it 'with status cancel' do
      danilo = User.create!(email: 'danilo@rmotors.com.br', password: '1234567')
      maicon = Professional.create!(email: 'maicon_comp@mail.com', password: '1234567')

      Profile.create!(name: 'maicon', description: 'Dev back-end laravel and django',
                      birth_date: '11/4/1990', professional: maicon)
      ecommerce = Project.create!(title: 'E-commerce de carros', description: 'uma plataforma para venda, '\
                                  'troca e compra de carros', deadline_submission: 1.week.from_now, remote: true,
                                  max_price_per_hour: 250, user: danilo)

      proposal_portal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                         completion_deadline: 50, professional: maicon, project: ecommerce,
                                         status: "cancel", feedback: "Vou participar de outro projeto")

      login_as danilo, scope: :user
      visit project_proposals_path(ecommerce)
      click_on "Visualizar Proposta"
      
      expect(page).to have_content('Feedback')
      expect(page).to have_content(proposal_portal.feedback)
    end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Users 
danilo = User.create!(email: 'danilo@rmotors.com.br', password: '1234567')
marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')
carlos = User.create!(email: 'carlos@lojasup.com', password: '1234567')
pedro = User.create!(email: 'pedro_calixto@mail.com', password: '123456')
debora = User.create!(email: 'carla.maria2@mail.com', password: '123456')
jackson = User.create!(email: 'jack_dev@c6consultoria.com.br', password: '123456')

#Professionals
maicon = Professional.create!(email: 'maicon_comp@mail.com', password: '1234567')
         Profile.create!(name: 'maicon', description: 'Dev back-end laravel and django',
                       birth_date: '11/4/1990', professional: maicon)
caio = Professional.create!(email: 'caio_comp@mail.com', password: '1234567')
         Profile.create!(name: 'caio', description: 'Dev front-end react',
                       birth_date: '11/4/1990', professional: caio)
diego = Professional.create!(email: 'diego_comp@mail.com', password: '1234567')
         Profile.create!(name: 'diego', description: 'Dev front-end vue js',
                       birth_date: '11/4/1990', professional: diego)
# Projects
ecommerce = Project.create!(title: 'E-commerce de carros', description: 'uma plataforma para venda, '\
                            'troca e compra de carros', deadline_submission: 1.week.from_now, remote: true,
                             max_price_per_hour: 250, user: danilo)
portal_escolar = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                'atividades escolares', deadline_submission: 5.days.from_now, remote: true,
                max_price_per_hour: 150, user: marcia)
tabuleiro = Project.create!(title: 'Criar arte para jogo de tabuleiro', description: 'Desenvolvimento de jogo de '\
                                   'tabuleiro, necessito de alguém para transformar minhas ideias em arte, como o tabuleiro'\
                                   'do jogo e cartas', max_price_per_hour: 300, deadline_submission: 2.weeks.from_now,
                                   remote: true, user: pedro)
Project.create!(title: 'Desenvolvimento Website', description: "Desenvolvimento de website costumizado",
                max_price_per_hour: 200, deadline_submission: 5.days.from_now, user: debora)

Project.create!(title: 'Criar diversas telas de um sistema em React.js', description: 'Preciso de um profissional com experiência '\
                'em React.js para construção de diversas telas de um sistema que esta sendo reescrito',
                max_price_per_hour: 270, deadline_submission: 12.days.from_now, user: carlos )

Project.create!(title: 'Integração de api', description: 'Preciso de um dev para integração de api no meu site.',
                max_price_per_hour: 300, deadline_submission: 3.days.from_now, user: jackson) 

#Proposals
proposal_portal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                   completion_deadline: 50, professional: diego, project: portal_escolar)
Proposal.create!(justification: 'tenho habilidades para esse projeto', price_hour: 100, weekly_hour: 30, 
                 completion_deadline: 30, professional: diego, project: ecommerce)
Proposal.create!(justification: "tenho habilidades para esse projeto", price_hour: 100, weekly_hour: 30,
                 completion_deadline: 25, professional: caio, project: ecommerce)
Proposal.create!(justification: "tenho habilidades para esse projeto", price_hour: 100, weekly_hour: 30,
                 completion_deadline: 40, professional: maicon, project: tabuleiro)

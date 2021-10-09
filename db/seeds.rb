# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
danilo = User.create!(email: 'danilo@rmotors.com.br', password: '1234567')
marcia = User.create!(email: 'prof_marcia@educacional.com.br', password: '1234567')

Project.create!(title: 'Ecommerce de carros', description: 'uma plataforma para venda, '\
                'troca e compra de carros', deadline_submission: '21/12/2021', remote: true,
                max_price_per_hour: 250, user: danilo)
Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
               'atividades escolares', deadline_submission: '10/10/2021', remote: true,
               max_price_per_hour: 150, user: marcia)

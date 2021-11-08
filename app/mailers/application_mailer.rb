# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'nao-responder@freelancerstech.com'
  layout 'mailer'
end

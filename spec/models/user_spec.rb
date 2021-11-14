# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require 'rails_helper'

describe User do
  context 'has many' do
    it 'projects' do
      should have_many(:projects)
    end
    it 'proposals' do
      should have_many(:proposals).through(:projects)
    end
  end
end

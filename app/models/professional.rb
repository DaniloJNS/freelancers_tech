class Professional < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :profile, dependent: :destroy
  has_many :proposals
  has_many :projects, through: :proposals
  def proposal_id_of_a project
    proposals.find_by(project_id: project.id)
  end
end

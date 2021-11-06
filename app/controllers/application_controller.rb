class ApplicationController < ActionController::Base
  before_action :profile_complete_professsional!

  private

  def after_sign_in_path_for(resource)
    if resource.instance_of? Professional and resource.profile
                                                      .blank?
      new_professional_profile_path(resource)
    else
      root_path
    end
  end

  def profile_complete_professsional!
    if current_professional.present? and current_professional.profile.blank?
      redirect_to(new_professional_profile_path(current_professional),
                  notice: 'Por favor complete seu perfil antes de acessar a plata'\
                          'forma', status: :moved_permanently)
    end
  end

  def authenticate_professional_user!
    redirect_to(root_path, notice: 'Faça o login') if current_professional.blank? and current_user.blank?
  end
end

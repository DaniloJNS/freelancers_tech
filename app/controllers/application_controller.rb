class ApplicationController < ActionController::Base
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
		   'forma')
    end
  end
end

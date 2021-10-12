class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if resource.class.eql? Professional 
      if resource.profile.nil?
	new_professional_profile_path(resource)
      else
	root_path
      end
    else
      root_path
    end
  end
end

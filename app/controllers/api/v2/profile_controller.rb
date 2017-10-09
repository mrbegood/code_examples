class Api::V2::ProfileController < ::Api::V1::ProfileController
  
private 
  def profilePresenter
    @profilePresenter ||= ::Api::V2::ProfilePresenter.new(resource, current_user)
  end
end

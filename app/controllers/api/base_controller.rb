class Api::BaseController < ::ApiController

  before_filter :require_resource
  
  # get request resource (User) object
  def resource
    @resource ||= Proc.new {
      if params[:id].blank?
        current_user
      else
        username, hostname = params[:id].to_s.split('@')
        User.find_by_username(username)
      end
    }.call
  end

  def require_resource
    raise RecordNotFound.new unless resource
  end
end

class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  
  include TokenAuthorization
  include JsonCache
  include RescueHelpers
  
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authorized!, only: [:not_authorized]
  
  # GET /authorized
  def token_authorization
    # используется в тестах для проверки прав доступа к закрытым методам api
    render_success 200, message: "authorized"
  end
  
end

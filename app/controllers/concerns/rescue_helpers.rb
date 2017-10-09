module RescueHelpers
  class RecordNotFound < StandardError; end
  class AccessDenied < StandardError; end
  
  include JsonResponse
  
  extend ActiveSupport::Concern
  
  included do
    rescue_from RescueHelpers::RecordNotFound, with: :record_not_found
    rescue_from RescueHelpers::AccessDenied, with: :access_denied
    
    def record_not_found
      render_error 404, message: "record not found"
    end
    
    def access_denied
      render_error 401, message: "access denied"
    end
  end
end

module JsonResponse
  extend ActiveSupport::Concern
  
  included do
    def render_success(http_status_code, object = {})
      render json: json_wrapper('success', object), status: http_status_code
    end
    
    def render_error(http_status_code, object = {})
      render json: json_wrapper('failed', object), status: http_status_code
    end
    
    private
    
    def json_wrapper(status, object)
      object.merge({ status: status })
    end
  end
end

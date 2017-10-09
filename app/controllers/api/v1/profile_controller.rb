class Api::V1::ProfileController < ::Api::BaseController
  def show
    render_success 200, data: profilePresenter
  end
  
  def update
    begin
      resource.update!(permited_params)
      
      # sync for push_id update with new version
      if permited_params[:push_id]
        resource.notification_settings.update_attribute(:push_id, permited_params[:push_id])
      end
      
      render_success 200, data: profilePresenter
    rescue Exception => exception
      render_error 422, errors: resource.errors.messages
    end
  end

  def skip_in_search
    begin
      current_user.search_ignores.create!(skipped_user_id: resource.id)
      render_success 200, message: "user successfully marked for skip"
    rescue Exception => exception
      render_error 422, error: "unknown error"
    end
  end

  private

  def profilePresenter
    @profilePresenter ||= ::Api::V1::ProfilePresenter.new(resource, current_user)
  end

  def permited_params
    params.require(:user).permit(
      :name,
      :avatar,
      :birthday,
      :gender,
      :about_me,
      :bio,
      :location,
      :latitude,
      :longitude,
      :instagram_id,
      :push_id,
      # user interests (UserTags), array of strings,
      :language => [],
      :education => [],
      :work => [],
      :music => [],
      :book => [],
      :video => [],
      :sport => [],
      :events => [],
      :likes => []
    )
  end
end

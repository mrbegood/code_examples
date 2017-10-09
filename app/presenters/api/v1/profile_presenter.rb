class Api::V1::ProfilePresenter
  def initialize(user, viewer, options = {})
    @user_id, @user = user.is_a?(User) ? [user.id, user] : [user]
    @viewer_id, @viewer = viewer.is_a?(User) ? [viewer.id, viewer] : [viewer]
    @options = options
  end
  
  def as_json(options = {})
    @options = @options.merge(options)
    
    # get/create cached data
    result_json = cached_data
    
    # add distance attribute if available
    if user.respond_to?(:distance)
      result_json[:distance] = user.distance.to_i
    end
    
    # other should not see our notification settings
    unless @user_id == @viewer_id
      result_json.delete("notifications")
    end
    
    result_json
  end

  
  def drop_cache
    Rails.cache.delete "profile_#{@user_id}_json"
  end
  
  private
    
  def user
    @user ||= User.find(@user_id)
  end
  
  def cached_data
    Rails.cache.fetch "profile_#{@user_id}_json" do
      user.as_json(json_default_options)
    end
  end
  
  def json_default_options
    {
      only: [
        # return base profile attirbutes
        :username, :name, :birthday, :gender, :location, :about_me, :bio, :facebook_id, :instagram_id
      ],
      # custom data
      methods: [
        :interests,
        :notifications,
        :picture,
        :subscribed_till
      ]
    }
  end
end

class UserProfilePresenter
  SearchJsonOptions = {
    only: [
      # basic profile info 
      :username, :name, :birthday, :gender, :about_me, :location, :facebook_id,
    ], 
    methods: [
      :interests,
      :picture,
      :debug
    ]
  }
  
  DefaultJsonOptions = {
    only: [
      # basic profile info 
      :username, :name, :birthday, :gender, :location, :about_me, :bio, :facebook_id, :instagram_id
    ],
    methods: [
      :interests,
      :notifications,
      :picture,
      :subscribed_till
    ]
  }
  
  def initialize(user, viewer, options = {})
    @user_id, @user = user.is_a?(User) ? [user.id, user] : [user]
    @viewer_id, @viewer = viewer.is_a?(User) ? [viewer.id, viewer] : [viewer]
    @options = options
  end
  
  def as_json(options = {})
    @options = @options.merge(options)
    output_json = version_cached_data(version)
    output_json[:distance] = user.distance.to_i if user.respond_to?(:distance)
    output_json.delete("notifications") unless @user_id == @viewer_id
    output_json
  end
  
  def version
    @options[:version] || :full
  end
  
  private
  
  def version_cached_data(version)
    case version
    when 'search'
      user.as_json(SearchJsonOptions)
    else
      user.as_json(DefaultJsonOptions)
    end
  end
  
  def user
    @user ||= User.find(@user_id)
  end
end

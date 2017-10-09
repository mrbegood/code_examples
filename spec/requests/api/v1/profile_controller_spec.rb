require "rails_helper"

RSpec.describe "Api::V1::ProfileController", :type => :request, session: false do
  describe "GET /profile" do
    it "should return current user profile" do
      @me = create(:user, :male, {
        location: "Belarus, Minsk",
        bio: "About me",
        about_me: "Welcome phrase"
      })
      
      api_call(:get, "/profile", {
        access_token: @me.current_token
      }) do |doc|
        expect(response).to have_http_status(200)
        expect(json_data.to_json).to eq(Api::V1::ProfilePresenter.new(@me, @me).to_json)
        expect(json_data).to have_key(:notifications)
      end
    end
  end
  
  describe "GET /profile/:id" do
    it "should return specified with :id user profile" do
      @me = create(:user, :male)
      @contact = create(:user, :male)
      
      api_call(:get, "/profile/:id", {
        access_token: @me.current_token,
        id: @contact.jid
      }) do |doc|
        expect(response).to have_http_status(200)
        expect(json_data.to_json).to eq(Api::V1::ProfilePresenter.new(@contact, @me).to_json)
        expect(json_data).not_to have_key(:notifications)
      end
    end
  end
  
  describe "PUT /profile/:id" do
    it "should update current user profile" do
      @me = create(:user, :male)
      
      @update_attributes = {
        name: "User Name",
        avatar: avatar_file,
        gender: User::Gender::Male,
        birthday: "2000-01-01",
        bio: "About me",
        about_me: "Welcome phrase",
        location: "Belarus, Minsk",
        instagram_id: "123454321",
        push_id: "123456789",
        latitude: "1.11111",
        longitude: "2.22222",
        language: ["English"],
        education: ["school", "university"],
        work: ["company #1", "company #1"],
        music: ["genre #1", "genre #2"],
        book: ["book #1", "book #2"],
        video: ["video #1", "video #2"],
        sport: ["sport #1", "sport #2"],
        events: ["events #1", "events #2"],
        likes: ["likes #1", "likes #2"]
      }
      
      api_call(:put, "/profile", {
        access_token: @me.current_token, 
        user: @update_attributes
      }) do |doc|
        expect(response).to have_http_status(200)
        response_json = json_data
        
        @update_attributes.keys.each do |key|
          if response_json[key].present?
            expect(response_json[key]).to eq(@update_attributes[key])
          end
        end
        
        @me.reload
        
        response_json[:interests].keys do |key|
          expect(response_json[:interests][key]).to eq(@me.interests[key])
        end
        
        expect(@me.push_id).to eq(@update_attributes[:push_id])
        expect(@me.notification_settings.push_id).to eq(@update_attributes[:push_id])
        
        expect(response_json[:picture][:url]).to eq(@me.avatar_url)
        expect(response_json[:picture][:url]).not_to eq("")
        
      end
    end
    
  end
  
  describe "POST /profile/:id/skip_in_search" do
    it "should add user to search ignore list" do
      @me = create(:user)
      @contact = create(:user)
      
      api_call(:post, "/profile/:id/skip_in_search", {
        access_token: @me.current_token,
        id: @contact.jid
      }) do |doc|
        expect(response).to have_http_status(200)
        expect(body_json[:message]).to eq("user successfully marked for skip")
        
        expect(@me.ignored_user_ids).to include(@contact.id)
      end
    end
  end  
  
  
end

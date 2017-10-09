require "rails_helper"

RSpec.describe "ApiController", :type => :request, session: false do

  describe "when valid access token in headers" do
    it "should process request" do
      @user = create(:user)
      
      api_call(:get, '/authorized', {}, {"BC-Authorize": @user.current_token}) do |doc|
        doc[:summary] = <<-desc
### Доступ к защищённым методам API
Для доступа к защищённым методам необходимо передавать токен авторизации, получаемый при успешном выполнении запроса  
`POST /authorize`
desc

        doc[:description] = "Передача токена авторизации в хедерах запроса"
        
        expect(response).to have_http_status(200)
        expect(body_json[:message]).to eq("authorized")
      end
    end
  end
  
  describe "when valid access token in params[:token]" do
    it "should process request" do
      @user = create(:user)
      
      api_call(:get, '/authorized', {token: @user.current_token}) do |doc|
        doc[:description] = "Передача токена авторизации в params[:access]"
        
        expect(response).to have_http_status(200)
        expect(body_json[:message]).to eq("authorized")
      end
    end
  end
  
  describe "when valid access token in params[:access_token]" do
    it "should process request" do
      @user = create(:user)
      
      api_call(:get, '/authorized', {access_token: @user.current_token}) do |doc|
        doc[:description] = "Передача токена авторизации в params[:access_token]"
        
        expect(response).to have_http_status(200)
        expect(body_json[:message]).to eq("authorized")
      end
    end
  end
  
  describe "when access denied" do
    it "should return error (401 Unauthorized)" do
      api_call(:get, '/authorized', {access_token: 'invalid_value'}) do |doc|
        doc[:description] = "Доступ ограничен"
        
        expect(response).to have_http_status(401)
        expect(body_json[:message]).to eq("access denied")
      end
    end
  end
  
end

module Admin::BasicAuthRequestHelper
  def basic_auth_headers
    user = ENV["BASIC_AUTH_USER"]
    password = ENV["BASIC_AUTH_PASSWORD"]

    { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(user, password) }
  end
end

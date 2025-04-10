module AuthorizeRequest
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request
  end

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    user_id = AuthenticationTokenService.decode(token)
    @current_user = User.find(user_id)

    render json: { error: [ "Unauthorized" ] }, status: :unauthorized unless @current_user
  rescue
    render json: { error: [ "Unauthorized" ] }, status: :unauthorized
  end
end

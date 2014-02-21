require 'api_responder'

class Api::ApiController < ActionController::Metal
  include AbstractController::ViewPaths
  include AbstractController::Callbacks

  include ActiveSupport::Rescuable

  include ActionController::Head
  include ActionController::Rendering
  include ActionController::Renderers::All
  include ActionController::MimeResponds
  include ActionController::Rescue
  include ActionController::StrongParameters

  include Doorkeeper::Helpers::Filter

  prepend_view_path File.join(Rails.root, 'app', 'views')
  append_view_path ::File.expand_path('../../../views/api', __FILE__)

  self.responder = ApiResponder

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  respond_to :json

  doorkeeper_for :all

  def current_user
    if doorkeeper_token
      @current_user ||= User.find(doorkeeper_token.resource_owner_id)
    end
  end

  def not_found
    render 'errors/not_found', status: :not_found
  end

  def parameter_missing
    @exception = exception
    render 'errors/parameter_missing', status: :bad_request
  end

  #def forbidden_operation!
  #  render 'errors/forbidden_operation', status: :forbidden and return
  #end
end

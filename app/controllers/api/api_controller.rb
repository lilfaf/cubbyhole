require 'api_responder'
require 'errors'

class Api::ApiController < ActionController::Metal
  include AbstractController::ViewPaths
  include AbstractController::Callbacks

  include ActiveSupport::Rescuable

  include ActionController::Head
  include ActionController::Rendering
  include ActionController::ImplicitRender
  include ActionController::MimeResponds
  include ActionController::Rescue
  include ActionController::StrongParameters

  include Doorkeeper::Helpers::Filter

  prepend_view_path File.join(Rails.root, 'app', 'views')
  append_view_path File.expand_path('../../../views/api', __FILE__)

  self.responder = ApiResponder
  respond_to :json

  # Handle exceptions and respond with a friendly error message
  rescue_from Exception, with: :error_during_processing
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from Errors::ForbiddenOperation, with: :forbidden_operation

  doorkeeper_for :all

  def current_user
    if doorkeeper_token
      @current_user ||= User.from_token(doorkeeper_token)
    end
  end

  def invalid_record!(record)
    @record = record
    render 'errors/invalid_record', status: :unprocessable_entity
  end

  private

  def error_during_processing(exception)
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.join("\n")
    render text: { exception: exception.message }.to_json, status: 500 and return
  end

  def not_found
    render 'errors/record_not_found', status: :not_found and return
  end

  def parameter_missing
    @exception = exception
    render 'errors/parameter_missing', status: :bad_request and return
  end

  def forbidden_operation
    render 'errors/forbidden_operation', status: :forbidden and return
  end
end

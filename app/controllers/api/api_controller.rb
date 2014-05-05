require 'api_controller_setup'
require 'errors'

class Api::ApiController < ActionController::Metal
  include ApiControllerSetup

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
    render json: { message: t('errors.invalid_record'), errors: record.errors }, status: :unprocessable_entity
  end

  private

  def error_during_processing(exception)
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.join("\n")
    render text: { exception: exception.message }.to_json, status: 500 and return
  end

  def not_found
    render json: { message: t('errors.not_found') }, status: :not_found and return
  end

  def parameter_missing
    render json: { message: t('errors.parameter_misssing', param: 'exception.param') }, status: :bad_request and return
  end

  def forbidden_operation
    render json: { message: t('errors.forbidden_operation') }, status: forbidden and return
  end
end

require 'api_responder'

module ApiControllerSetup
  def self.included(klass)
    klass.class_eval do
      include AbstractController::Callbacks
      include ActiveSupport::Rescuable
      include ActionController::Head
      include ActionController::Rendering
      include ActionController::Renderers::All
      include ActionController::ImplicitRender
      include ActionController::Serialization
      include ActionController::MimeResponds
      include ActionController::Rescue
      include ActionController::StrongParameters
      include ActionView::Helpers::TranslationHelper
      include Doorkeeper::Helpers::Filter

      self.responder = ApiResponder
      respond_to :json
    end
  end
end


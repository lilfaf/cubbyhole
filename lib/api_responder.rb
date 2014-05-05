class ApiResponder < ActionController::Responder
  def api_behavior(error)
    if post?
      display resource, status: :created
    elsif put?
      display resource, status: :ok
    else
      super
    end
  end
end

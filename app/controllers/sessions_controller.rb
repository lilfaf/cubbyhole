class SessionsController < Devise::SessionsController
  def create
    super do |resource|
      resource.generate_access_token!
    end
  end

  def destroy
    resource.delete_tokens
    super
  end
end

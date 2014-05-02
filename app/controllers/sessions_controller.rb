class SessionsController < Devise::SessionsController
  def create
    super do |resource|
      resource.generate_access_token!
    end
  end

  def destroy
    current_user.delete_token
    super
  end
end

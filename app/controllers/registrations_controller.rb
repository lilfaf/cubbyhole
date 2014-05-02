class RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      resource.generate_access_token! if resource.persisted?
    end
  end
end

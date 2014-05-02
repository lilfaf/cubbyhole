module TokenAuthenticatable
  extend ActiveSupport::Concern

  def generate_access_token!
    Doorkeeper::AccessToken.create!(token_attributes)
  end

  def access_tokens
    Doorkeeper::AccessToken.where(application_id: web_client.id, resource_owner_id: id)
  end

  def token
    access_tokens.first.token
  end

  def delete_token
    access_tokens.delete_all
  end

  private

  def web_client
    @client ||= Doorkeeper::Application.find_by_name('web')
  end

  def token_attributes
    {
      application_id: web_client.id,
      resource_owner_id: self.id,
      scopes: 'public write',
      expires_in: nil,
      use_refresh_token: false
    }
  end

  module ClassMethods
    def from_token(token)
      find(token.resource_owner_id)
    end
  end
end

class CurrentUserSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :email, :username, :auth_token

  def auth_token
    object.token
  end
end

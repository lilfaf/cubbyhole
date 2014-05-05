class CurrentUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :auth_token

  def auth_token
    object.token
  end
end

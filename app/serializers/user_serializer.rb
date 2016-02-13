class UserSerializer < ActiveModel::Serializer
  cached

  embed :ids
  attributes :id, :email, :created_at, :updated_at, :auth_token
  has_many :posts

  def cache_key
    [object, scope]
  end
end

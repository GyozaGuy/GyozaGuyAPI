class PostSerializer < ActiveModel::Serializer
  cached
  
  attributes :id, :title, :time, :content, :published
  has_one :user

  def cache_key
    [object, scope]
  end
end

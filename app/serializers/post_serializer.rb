class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :time, :content, :published
  has_one :user
end

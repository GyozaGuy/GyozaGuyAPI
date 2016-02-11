class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :time, :content, :published
end

class Post < ActiveRecord::Base
  validates :title, :time, :content, :user_id, presence: true
  # validates :time, :timeliness, presence: true # TODO: maybe use https://github.com/adzap/validates_timeliness
end

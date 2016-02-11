class Post < ActiveRecord::Base
  validates :title, :time, :content, :user_id, presence: true
  # validates :time, :timeliness, presence: true # TODO: maybe use https://github.com/adzap/validates_timeliness
  belongs_to :user
  scope :filter_by_title, lambda { |keyword| where("lower(title) LIKE ?", "%#{keyword.downcase}%") }
  scope :before_or_equal_to_time, lambda { |time| where("time <= ?", time) }
  scope :after_or_equal_to_time, lambda { |time| where("time >= ?", time) }
  scope :recent, -> { order(:updated_at) }
end

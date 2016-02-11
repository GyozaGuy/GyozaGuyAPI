class Post < ActiveRecord::Base
  validates :title, :time, :content, :user_id, presence: true
  # validates :time, :timeliness, presence: true # TODO: maybe use https://github.com/adzap/validates_timeliness
  belongs_to :user
  scope :filter_by_title, lambda { |keyword| where("lower(title) LIKE ?", "%#{keyword.downcase}%") }
  scope :filter_by_content, lambda { |keyword| where("lower(content) LIKE ?", "%#{keyword.downcase}%") }
  scope :filter_by_title_or_content, lambda { |keyword| where("lower(title) LIKE ? OR lower(content) LIKE ?", "%#{keyword.downcase}%", "%#{keyword.downcase}%") }
  # TODO: fix the stuff below to use the built in columns rather than 'time'
  scope :before_or_equal_to_time, lambda { |time| where("time <= ?", time) }
  scope :after_or_equal_to_time, lambda { |time| where("time >= ?", time) }
  scope :recent, -> { order(:updated_at) }

  def self.search(params = {})
    posts = params[:post_ids].present? ? Post.find(params[:post_ids]) : Post.all

    posts = posts.filter_by_title(params[:title_keyword]) if params[:title_keyword]
    posts = posts.filter_by_content(params[:content_keyword]) if params[:content_keyword]
    posts = posts.filter_by_title_or_content(params[:keyword]) if params[:keyword]
    posts = posts.before_or_equal_to_time(params[:max_time]) if params[:max_time]
    posts = posts.after_or_equal_to_time(params[:min_time]) if params[:min_time]
    posts = posts.recent(params[:recent]) if params[:recent].present?

    posts
  end
end

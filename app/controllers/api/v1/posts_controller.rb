class Api::V1::PostsController < ApplicationController
  before_action :authenticate_with_token!, only: :create
  respond_to :json

  def index
    respond_with Post.all
  end

  def show
    respond_with Post.find(params[:id])
  end

  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: post, status: 201, location: [:api, post]
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  def update
    post = current_user.posts.find(params[:id])
    if post.update(post_params)
      render json: post, status: 200, location: [:api, post]
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    head 204
  end

  private

  def post_params
    params.require(:post).permit(:title, :time, :content, :published)
  end
end

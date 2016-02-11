require 'spec_helper'

describe Api::V1::PostsController do
  describe 'GET #show' do
    before(:each) do
      @post = FactoryGirl.create :post
      get :show, id: @post.id
    end

    it 'returns the information about a reporter on a hash' do
      post_response = json_response
      expect(post_response[:title]).to eql @post.title
    end

    it { should respond_with 200 }
  end

  describe 'GET #index' do
    before(:each) do
      4.times { FactoryGirl.create :post }
      get :index
    end

    it 'returns 4 records from the database' do
      posts_response = json_response
      expect(posts_response).to have(4).items
    end

    it { should respond_with 200 }
  end
end

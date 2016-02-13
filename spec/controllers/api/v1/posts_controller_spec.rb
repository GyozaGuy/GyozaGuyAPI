require 'spec_helper'

describe Api::V1::PostsController do
  describe 'GET #show' do
    before(:each) do
      @post = FactoryGirl.create :post
      get :show, id: @post.id
    end

    it 'has the user as an embedded object' do
      post_response = json_response[:post]
      expect(post_response[:user][:email]).to eql @post.user.email
    end

    it 'returns the information about a reporter on a hash' do
      post_response = json_response[:post]
      expect(post_response[:title]).to eql @post.title
    end

    it { should respond_with 200 }
  end

  describe 'GET #index' do
    before(:each) do
      4.times { FactoryGirl.create :post }
      get :index
    end

    context 'when is not receiving any product_ids parameter' do
      before(:each) do
        get :index
      end

      it 'returns 4 records from the database' do
        posts_response = json_response
        expect(posts_response[:posts]).to have(4).items
      end

      it 'returns the user object into each post' do
        posts_response = json_response[:posts]
        posts_response.each do |post_response|
          expect(post_response[:user]).to be_present
        end
      end

      it { expect(json_response).to have_key(:meta) }
      it { expect(json_response[:meta]).to have_key(:pagination) }
      it { expect(json_response[:meta][:pagination]).to have_key(:per_page) }
      it { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
      it { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }

      it { should respond_with 200 }
    end

    context 'when post_ids parameter is sent' do
      before(:each) do
        @user = FactoryGirl.create :user
        3.times { FactoryGirl.create :post, user: @user }
        get :index, post_ids: @user.post_ids
      end

      it 'returns just the posts that belong to the user' do
        posts_response = json_response[:posts]
        posts_response.each do |post_response|
          expect(post_response[:user][:email]).to eql @user.email
        end
      end
    end

    it 'returns the user object into each post' do
      posts_response = json_response[:posts]
      posts_response.each do |post_response|
        expect(post_response[:user]).to be_present
      end
    end

    it 'returns 4 records from the database' do
      posts_response = json_response
      expect(posts_response[:posts]).to have(4).items
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        user = FactoryGirl.create :user
        @post_attributes = FactoryGirl.attributes_for :post
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, post: @post_attributes }
      end

      it 'renders the json representation for the post record just created' do
        post_response = json_response[:post]
        expect(post_response[:title]).to eql @post_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_post_attributes = { title: 'Test', time: 'hi there' }
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, post: @invalid_post_attributes }
      end

      it 'renders an errors json' do
        post_response = json_response
        expect(post_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        post_response = json_response
        expect(post_response[:errors][:time]).to include "can't be blank"
        expect(post_response[:errors][:content]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @user = FactoryGirl.create :user
      @post = FactoryGirl.create :post, user: @user
      api_authorization_header @user.auth_token
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, { user_id: @user.id, id: @post.id, post: { title: 'A test title' } }
      end

      it 'renders the json representation for the updated user' do
        post_response = json_response[:post]
        expect(post_response[:title]).to eql 'A test title'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, { user_id: @user.id, id: @post.id, post: { time: 'yesterday' } }
      end

      it 'renders an errors json' do
        post_response = json_response
        expect(post_response).to have_key(:errors)
      end

      it 'renders the json errors on why the post could not be updated' do
        post_response = json_response
        expect(post_response[:errors][:time]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      @post = FactoryGirl.create :post, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, { user_id: @user.id, id: @post.id }
    end

    it { should respond_with 204 }
  end
end

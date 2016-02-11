require 'spec_helper'

describe Post do
  let(:post) { FactoryGirl.build :post }
  subject { post }

  it { should respond_to(:title) }
  it { should respond_to(:time) }
  it { should respond_to(:content) }
  it { should respond_to(:published) }
  it { should respond_to(:user_id) }

  # it { should not_be_published } # Fails because of a missing variable

  it { should validate_presence_of :title }
  it { should validate_presence_of :time }
  # it { should validate_timeliness_of :time } # TODO: maybe use https://github.com/adzap/validates_timeliness
  it { should validate_presence_of :content }
  it { should validate_presence_of :user_id }
end

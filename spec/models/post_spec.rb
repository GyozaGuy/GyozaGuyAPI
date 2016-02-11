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
  it { should belong_to :user }

  describe '.filter_by_title' do
    before(:each) do
      @post1 = FactoryGirl.create :post, title: 'Test post 1 of doom'
      @post2 = FactoryGirl.create :post, title: 'Test post 2'
      @post3 = FactoryGirl.create :post, title: 'Test post of doom 3'
      @post4 = FactoryGirl.create :post, title: 'Test post 4'
    end

    context "when a 'doom' title pattern is sent" do
      it 'returns the 2 posts matching' do
        expect(Post.filter_by_title('doom')).to have(2).items
      end

      it 'returns the posts matching' do
        expect(Post.filter_by_title('doom').sort).to match_array([@post1, @post3])
      end
    end
  end

  describe '.before_or_equal_to_time' do
    before(:each) do
      @post1 = FactoryGirl.create :post, time: Time.now
      @post2 = FactoryGirl.create :post, time: Time.at(628232400)
      @post3 = FactoryGirl.create :post, time: Time.now + 1.day
      @post4 = FactoryGirl.create :post, time: 1.day.ago
    end

    it 'returns the posts which are before or equal to the time' do
      expect(Post.before_or_equal_to_time(Time.now).sort).to match_array([@post1, @post2, @post4])
    end
  end

  describe '.after_or_equal_to_time' do
    before(:each) do
      @post1 = FactoryGirl.create :post, time: Time.now
      @post2 = FactoryGirl.create :post, time: Time.at(628232400)
      @post3 = FactoryGirl.create :post, time: Time.now + 1.day
      @post4 = FactoryGirl.create :post, time: 1.day.ago
    end

    it 'returns the posts which are after or equal to the time' do
      expect(Post.after_or_equal_to_time(Time.now).sort).to match_array([@post3]) # The original Time.now used on post1 is no longer current so should not match
    end
  end

  describe '.recent' do
    before(:each) do
      @post1 = FactoryGirl.create :post, time: Time.now
      @post2 = FactoryGirl.create :post, time: Time.at(628232400)
      @post3 = FactoryGirl.create :post, time: Time.now + 1.day
      @post4 = FactoryGirl.create :post, time: 1.day.ago
      @post2.touch
      @post3.touch
    end

    it 'returns the most updated records' do
      expect(Post.recent).to match_array([@post3, @post2, @post4, @post1])
    end
  end
end

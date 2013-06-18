require 'spec_helper'

describe LocationPost do
  it 'should be possible to create a valid location post' do
    post = LocationPost.new
    post.content = 'content'
    post.save!
    post.valid?.should be_true
    post.content.should eq('content')
  end
end

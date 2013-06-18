require 'spec_helper'

describe Comment do

  after :all do
    User.destroy
    Comment.destroy
  end

  it 'should be possible to create a comment' do
    person = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    person.save!
    comment = Comment.new :user => person, :content => 'Hello', :rating => 2
    comment.save!
    comment.user.should equal(person)
    comment.content.should eq('Hello')
    comment.rating.should eq(2)
  end
end

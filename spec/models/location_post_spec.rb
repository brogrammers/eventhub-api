require 'spec_helper'

describe LocationPost do
  fixtures :core_users, :users, :location_posts, :locations

  it 'should be possible to create a valid location post' do
    location_post = location_posts :one
    location_post.save!
    location_post.content.should == 'Location Post'
    location_post.location.locationable.should == location_post
    location_post.user.location_posts.should include(location_post)
  end

  it 'should destroy location when location post is destroyed' do
    location_post = location_posts :one
    location_post.save!
    location_id = location_post.location.id
    location_post.destroy
    expect{Location.find location_id}.to raise_error(ActiveRecord::RecordNotFound)
  end

  context 'validation' do

    it 'should not be possible to create a location post without user' do
      location_post = location_posts :one
      location_post.user = nil
      expect{location_post.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a location post without location' do
      location_post = location_posts :one
      location_post.location = nil
      expect{location_post.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a location post without content' do
      location_post = location_posts :one
      location_post.content = nil
      expect{location_post.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a location post with content consisting less than 5 characters' do
      location_post = location_posts :one
      location_post.content = 'abcd'
      expect{location_post.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a location post with content consiting more than 512 characters' do
      location_post = location_posts :one
      location_post.content = Array.new(513){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
      expect{location_post.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

end

require 'spec_helper'

describe Comment do
  fixtures :users, :comments, :places, :core_users

  it 'should be possible to create a valid comment' do
    comment = comments :one
    comment.save!
    comment.should_not be_nil
    comment.content.should == 'Hello World'
    comment.rating.should == 5
    comment.user.should_not be_nil
    comment.commentable.should_not be_nil
  end

  context 'validations' do

    it 'should not be possible to create place without commenable set' do
      comment = comments :one
      comment.commentable = nil
      expect{comment.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a comment without user set' do
      comment = comments :one
      comment.user = nil
      expect{comment.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a comment without content set' do
      comment = comments :one
      comment.content = nil
      expect{comment.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a comment with rating set' do
      comment = comments :one
      comment.rating = nil
      expect{comment.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a comment with content consisting more than 1024 characters' do
      comment = comments :one
      comment.content = Array.new(1025){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
      expect{comment.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a comment with content consisting less than 5 characters' do
      comment = comments :one
      comment.content = 'abcd'
      expect{comment.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a comment with rating of more than 5 ' do
      comment = comments :one
      comment.rating = 6
      expect{comment.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a comment with rating of less than 0' do
      comment = comments :one
      comment.rating = -1
      expect{comment.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

end

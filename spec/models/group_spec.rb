require 'spec_helper'

describe Group do
  fixtures :groups, :destinations

  it 'should not create a valid new group record' do
    group = Group.new
    expect { group.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should attach a new destination' do
    destination = destinations :one
    group = groups :one
    group.destinations << destination
    group.save!
    group.destinations.size.should == 1
  end

  it 'should delete all destinations if group is deleted' do
    group = groups :one
    destination = destinations :one
    group.destinations << destination
    group.save!
    destination.save!
    group.destroy
    expect { Destination.find destination.id }.to raise_error(ActiveRecord::RecordNotFound)
  end

end


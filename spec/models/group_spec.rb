require 'spec_helper'

describe Group do

  before :all do
    @groups = YAML.load_file File.join(File.dirname(__FILE__), '..', 'fixtures', 'groups.yml')
  end

  after :all do
    Group.destroy_all
  end

  it 'should create a new valid group object' do
    group = Group.new
    group.name = @groups['one']['name']
    group.description = @groups['one']['description']
    group.name.should eq(@groups['one']['name'])
    group.description.should eq(@groups['one']['description'])
    expect(group.save!).to be_true
  end

  it 'should attach a new destination' do
    destination = Destination.new
    group = Group.new
    group.destinations << destination
    group.destinations.size.should eq(1)
  end

  it 'should delete all destinations if group is deleted' do
    group = Group.new
    destination = Destination.new
    group.destinations << destination
    group.save!
    destination.save!
    group.destroy
    Destination.all.size.should eq(0)
  end

end


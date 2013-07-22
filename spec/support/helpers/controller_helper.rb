module ControllerHelper

  def create_a_place(options = { })
    post :create, :name   => options[:name]             || 'test place',
         :description     => options[:description]      || 'description',
         :visibility_type => options[:visibility_type]  || 'public',
         :latitude        => options[:latitude]         || '55.555555',
         :longitude       => options[:longitude]        || '55.555555'
  end

  def update_a_place(options = { })
    put :update, :id      => options[:id],
         :name            => options[:name],
         :description     => options[:description],
         :visibility_type => options[:visibility_type],
         :latitude        => options[:latitude],
         :longitude       => options[:longitude]
  end

end

RSpec.configuration.send :include, ControllerHelper, :type => :controller
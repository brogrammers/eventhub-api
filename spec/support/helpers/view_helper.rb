module ViewHelper

  def render_me_index_view_json
    @user = users :one
    render_view @user, :object => 'me', :partial => 'index'
  end

  def render_me_devices_view_json
    @device = devices :one
    render_view @device, :object => 'me', :partial => 'device', :object_name => 'device'
  end

  def render_me_group_view_json
    @group = groups :one
    render_view @group, :object => 'me', :partial => 'group', :object_name => 'group'
  end

  def render_me_identity_view_json
    @identity = identities :one
    render_view @identity, :object => 'me', :partial => 'identity', :object_name => 'identity'
  end

  def render_me_location_view_json
    @location = locations :one
    render_view @location, :object => 'me', :partial => 'location', :object_name => 'location'
  end

  def render_me_location_post_view_json
    @location_post = location_posts :one
    render_view @location_post, :object => 'me', :partial => 'location_post', :object_name => 'location_post'
  end

  def render_me_notification_view_json
    @notification = notifications :one
    render_view @notification, :object => 'me', :partial => 'notification', :object_name => 'notification'
  end

  def render_me_place_view_json
    @place = places :one
    render_view @place, :object => 'me', :partial => 'place', :object_name => 'place'
  end

  def render_errors_record_invalid
    @place = places :one
    render_view @place, :object => 'errors', :partial => 'record_invalid', :object_name => 'error'
  end

  def render_errors_record_not_found
    @place = places :one
    render_view @place, :object => 'errors', :partial => 'record_not_found', :object_name => 'error'
  end

  def render_view(object, options = { })
    @rendered_view = JSON.parse(Rabl::Renderer.json(object, "api/v1/#{options[:object]}/#{options[:partial]}"))[options[:object_name] || options[:object]]
  end

  def key_exists?(key)
    !@rendered_view[key].nil?
  end

  def key_is_a_string?(key)
    @rendered_view[key].class == String
  end

  def key_is_boolean?(key)
    @rendered_view[key].class == TrueClass or @rendered_view[key].class == FalseClass
  end

  def key_is_an_array?(key)
    @rendered_view[key].class == Array
  end

  def key_is_a_hash?(key)
    @rendered_view[key].class == Hash
  end

  def key_is_an_integer?(key)
    @rendered_view[key].class == Fixnum
  end

  def key_is_a_float?(key)
    @rendered_view[key].class == Float
  end

end

RSpec.configuration.send :include, ViewHelper, :type => :view
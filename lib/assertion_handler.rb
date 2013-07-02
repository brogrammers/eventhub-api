class AssertionHandler
  class ClientUnknownError < StandardError; end
  class AssertionTypeUnknownError < StandardError; end
  class MissingAssertionTypeError < StandardError; end
  class MissingAssertionError < StandardError; end
  class InvalidAssertionError < StandardError; end

  attr_accessor :identity

  def initialize(type, assertion, client, scope)
    @assertion = assertion
    @client = client
    @scope = scope
    @done = false
    begin
      @type = type.to_sym
    rescue NoMethodError
      raise MissingAssertionTypeError
    end
    raise MissingAssertionError unless @assertion
    raise ClientUnknownError unless @client
  end

  def assert
    find_identity provider_response['id']
    update_user if identity and !@done
    register_user if !identity and provider_response['id'] and provider_response['name'] and !@done
    @done = true
    @user
  end

  private

  def provider_response
    @provider_response ||= begin
      case @type
        when :facebook
          facebook
        else
          raise AssertionTypeUnknownError
      end
    end
  end

  def facebook
    @facebook ||= begin
      graph = Koala::Facebook::API.new @assertion
      graph.get_object 'me', :fields => 'id,name'
    rescue Koala::Facebook::AuthenticationError
      raise InvalidAssertionError
    end
  end

  def twitter
    @twitter ||= begin
      # resolve twitter request
    end
  end

  def find_identity(id)
    @identity = Identity.find_by_provider_id id
  rescue ActiveRecord::RecordNotFound
    @identity = nil
  end

  def update_user
    @identity.token = @assertion
    @identity.save!
    @user = @identity.user
  end

  def register_user
    identity_obj = Identity.new :provider_id => provider_response['id'], :token => @assertion
    identity_obj.save!
    @user = User.new :name => provider_response['name'], :availability => true, :registered => true, :registered_at => Time.now
    @user.identities << identity_obj
    @user.save!
  end

end
require 'spec_helper'

describe 'AccessToken' do

  before :all do
    create_oauth_application
  end

  context 'assertion' do

    context 'valid' do

      before :all do
        class AssertionHandler
          def facebook
            { 'id' => '123', 'name' => 'Max' }
          end
        end
      end

      it 'should create an access token via valid assertion' do
        params = { :client => @application, :assertion_type => 'facebook', :assertion => 'abc' }
        expect do
          post '/oauth/token', assertion_endpoint_url(params)
        end.to change(Doorkeeper::AccessToken, :count).by(1)
      end

    end

    context 'invalid' do

      before :all do
        class AssertionHandler
          def facebook
            raise InvalidAssertionError
          end
        end
      end

      it 'should not create an access token via invalid assertion' do
        params = { :client => @application, :assertion_type => 'facebook', :assertion => 'invalid_assertion' }
        expect do
          post '/oauth/token', assertion_endpoint_url(params)
        end.to raise_error(AssertionHandler::InvalidAssertionError)
      end

      it 'should not create an access token if the assertion type is not supported' do
        params = { :client => @application, :assertion_type => 'invalid', :assertion => 'abc' }
        expect do
          post '/oauth/token', assertion_endpoint_url(params)
        end.to raise_error(AssertionHandler::AssertionTypeUnknownError)
      end

    end

  end

end
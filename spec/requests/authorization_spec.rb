require 'spec_helper'

describe 'Authorization' do

  it 'should respond with 401 if no access token is attached' do
    pending 'Once we have a Controller we can include this test'
    get('/api/v1/me').should == 401
  end

  it 'should respond with 401 if invalid access token is attached' do
    pending 'Once we have a Controller we can include this test'
    @request.env['HTTP_AUTHORIZATION'] = 'Bearer invalid token'
    get('/api/v1/me').should == 401
  end

end
require 'spec_helper'

describe 'Authorization' do

  it 'should respond with 401 if no access token is attached' do
    get('/api/v1/me').should == 401
  end

  it 'should respond with 401 if invalid access token is attached' do
    get('/api/v1/me', nil, { 'HTTP_AUTHORIZATION' => 'Bearer invalid token' }).should == 401
  end

end
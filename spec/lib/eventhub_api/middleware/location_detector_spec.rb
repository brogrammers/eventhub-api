require 'spec_helper'

describe EventhubApi::Middleware::LocationDetector do

  let(:middleware) { Proc.new { |env| [200, {}, ['']] } }
  let(:location_detector) { EventhubApi::Middleware::LocationDetector.new middleware }

  context '.valid_location?' do

    context 'with valid' do
      context 'latitude and longitude' do
        it { should == true }
        subject { location_detector.valid_location? }
      end
      before { location_detector.latitude, location_detector.longitude = '1.234567', '45.223234' }
    end

    context 'with invalid' do
      context 'latitude and longitude' do
        it { should == false }
        subject { location_detector.valid_location? }
      end
      before { location_detector.latitude, location_detector.longitude = '1', '45' }
    end

  end

  context 'as middleware' do
    subject { environment['user.location'] }
    before { app.call environment }
    let(:app) { EventhubApi::Middleware::LocationDetector.new middleware }

    context 'with valid' do
      context 'latitude' do
        it { should == '55.5555555' }
        subject { environment['user.location'][:latitude] }
      end

      context 'longitude' do
        it { should == '55.5555555' }
        subject { environment['user.location'][:longitude] }
      end
      let(:environment) { { 'HTTP_X_LOCATION' => '55.5555555:55.5555555' } }
    end

    context 'with invalid' do
      context 'latitude' do
        it { should be_nil }
      end

      context 'longitude' do
        it { should be_nil }
      end
      subject { environment['user.location'] }
      let(:environment) { { 'HTTP_X_LOCATION' => 'lkdsf' } }
    end

  end

end
require 'spec_helper'

describe Ringflux do
  subject { Ringflux }

  describe 'Ringflux.do_something' do
    let(:connection) { double 'Ringflux::Plugin.connection' }

    it 'gets sent to Redis' do
      Ringflux::Plugin.stub(:connection).and_return connection
      connection.should_receive(:set).with "foo", "bar"

      Ringflux.set "foo", "bar"
    end
  end
end

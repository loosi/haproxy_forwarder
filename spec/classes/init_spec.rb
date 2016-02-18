require 'spec_helper'
describe 'haproxy_forwarder' do

  context 'with defaults for all parameters' do
    it { should contain_class('haproxy_forwarder') }
  end
end

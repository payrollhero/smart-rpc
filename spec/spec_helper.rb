$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'ostruct'
require 'webmock/rspec'

RSpec.configure do |config|
  config.before do
    WebMock.disable_net_connect!
  end
  config.after do
    WebMock.allow_net_connect!
  end
  config.mock_with :rspec
  config.order = 'random'

  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true
end

require 'smart-rpc.rb'

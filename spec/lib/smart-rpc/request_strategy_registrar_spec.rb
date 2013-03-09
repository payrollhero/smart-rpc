require 'spec_helper'

describe SmartRpc::RequestStrategyRegistrar do
  module SmartRpc::RequestHandler
    class Test < Base; end
  end

  subject{ SmartRpc::RequestStrategyRegistrar.new }

  let(:registered_strategies){ subject.instance_variable_get('@registered_strategies') }

  describe "#initialize" do

    it "should already contain base strategy" do
      registered_strategies[:base].should be_a SmartRpc::RequestHandler::Base
    end
  end

  describe "#register" do
    it "should register a new handler with the request strategies" do
      subject.register(:test)
      registered_strategies[:test].should be_a SmartRpc::RequestHandler::Test
    end
  end

  describe "#get" do
    before{ subject.register(:test) }

    it "should get the handler for the specific strategy" do
      subject.get(:test).should be_an_instance_of SmartRpc::RequestHandler::Test
    end
  end
end

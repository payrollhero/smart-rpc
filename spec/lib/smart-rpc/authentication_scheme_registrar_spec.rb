require 'spec_helper'

describe SmartRpc::AuthenticationSchemeRegistrar do
  subject do
    SmartRpc::AuthenticationSchemeRegistrar.new
  end

  describe "#register" do
    it "should register an authentication scheme for a given strategy" do
      subject.register('api_key', 'http')
      subject.get('api_key', 'http').should respond_to(:generate_credentials_for)
    end

    context "when a strategy exists" do
      it "should return the registrar object itself" do
        subject.register('api_key', 'http').should eq(subject)
      end
    end

    context "when a strategy does not exist" do
      it "should raise an exception" do
        expect {subject.register('api_key', 'messaging_system')}.to raise_exception(SmartRpc::StrategyNotFoundError)
      end
    end
  end

  describe "#get" do
    context "when the strategy has been registered" do
      before :each do
        subject.register('api_key', 'http')
      end

      context "when the scheme has not been registered" do
        it "should raise an exception" do
          expect {subject.get('token_exchange', 'http')}.to raise_exception(SmartRpc::AuthenticationSchemeNotFoundError)
        end
      end

      context "when the scheme has been registered" do
        it "should return a scheme object" do
          subject.get('api_key', 'http').should respond_to(:generate_credentials_for)
        end
      end
    end

    context "when the strategy has not been registered" do
      it "should raise an exception" do
        expect {subject.get('token_exchange', 'http')}.to raise_exception(SmartRpc::StrategyNotFoundError)
      end
    end
  end
end

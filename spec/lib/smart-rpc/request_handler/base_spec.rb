require 'spec_helper'

describe SmartRpc::RequestHandler::Base do
  describe "register_actions" do
    it "should raise NotImplementedError" do
      expect{ subject.register_actions({}) }.to raise_error NotImplementedError
    end
  end

  describe "perform" do
    it "should raise NotImplementedError" do
      expect{ subject.perform({}) }.to raise_error NotImplementedError
    end
  end
end

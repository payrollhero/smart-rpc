require 'spec_helper'

describe SmartRpc::RequestHandler::Base do
  describe "perform" do
    it "should raise NotImplementedError" do
      expect{ subject.perform({}) }.to raise_error NotImplementedError
    end
  end
end

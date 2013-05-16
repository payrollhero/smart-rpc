require 'spec_helper'

describe SmartRpc::RequestHandler::Http::Authentication::Base do
  its(:credentials){ should == {} }

  describe "#generate_credentials_for" do
    it "should raise NotImplementedError" do
      expect{ subject.generate_credentials_for('blah') }.to raise_error NotImplementedError
    end
  end
end

require 'spec_helper'

describe SmartRpc::RequestHandler::Http::Authentication::Base do
  its(:credentials){ should == {} }

  describe "#generate_credentials_for" do
    it "should return the current object" do
      subject.generate_credentials_for('blah').should eq(subject)
    end
  end
end

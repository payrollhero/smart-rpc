require 'spec_helper'

class SmartRpc::RequestHandler::Http::Authentication::SomeScheme < SmartRpc::RequestHandler::Http::Authentication::Base
  def generate_credentials_for(app_name)
    @credentials = {:proof_of => :authenticity}
  end
end

describe SmartRpc::RequestHandler::Http::AuthenticationScheme do
  let(:schemes){ subject.instance_variable_get("@schemes")}

  describe "#initialize" do
    it "should initialize schemes" do
      subject; schemes.should == {}
    end
  end

  describe "#register" do
    it "should add the scheme" do
      subject.register(:some_scheme)
      schemes[:some_scheme].should == SmartRpc::RequestHandler::Http::Authentication::SomeScheme
    end
  end

  describe "#fetch_details" do
    before{ subject.register(:some_scheme) }

    it "should fetch authentication details for the scheme" do
      subject.fetch_details(:some_scheme, 'foo').should == {:proof_of => :authenticity}
    end
  end
end

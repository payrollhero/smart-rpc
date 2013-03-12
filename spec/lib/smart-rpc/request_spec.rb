require 'spec_helper'

describe SmartRpc::Request do
  before :each do
    SmartRpc::Setting.stub!(:config).and_return({
      'foo' => {
        'v1' => {
          'base_uri' => 'http://example.com',
          'root_path' => 'rest',
          'authentication_scheme' => 'api_key',
        },
        'authentication' => {
          'api_key' => {
            'api_key' => 'ABCDE'
          }
        }
      }
    })
  end

  let(:resource) do
    resource = OpenStruct.new(:id => 1, :name => 'Test', :data_for_create => {:id => 1, :name => 'Test'})
    resource.stub!(:id).and_return(1)
    resource
  end

  subject do
    authentication_scheme = SmartRpc::RequestHandler::Http::Authentication::ApiKey.new
    SmartRpc::Request.new('foo', 'v1', authentication_scheme)
  end

  describe "#initialize" do
    it "should set the app" do
      subject.app.should eq('foo')
    end

    it "should set the base location of the request" do
      subject.location.should eq("http://example.com/rest/v1")
    end

    it "should set the authentication scheme" do
      subject.authentication_data.should eq({:api_key => 'ABCDE'})
    end
  end

  describe "#set_resource_details" do
    it "should set the resource details for the request" do
      subject.set_resource_details(resource, :create)
      result = subject.resource_details
      result.action.should eq(:create)
      result.message.should eq({:id => 1, :name => "Test"})
      result.location.should eq("open_structs.json")
    end

    it "should return the request object" do
      subject.set_resource_details(resource, :create).should eq(subject)
    end
  end
end

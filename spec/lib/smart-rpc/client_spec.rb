require 'spec_helper'

describe SmartRpc::Client do
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

  class ClientTestResource
    def id; 3; end

    def data_for_read; {:account_id => 1}; end
  end

  let(:resource){ ClientTestResource.new }
  let(:options){ {:app => 'foo', :version => 'v1'} }

  subject{ SmartRpc::Client.new(options) }

  describe "#initialize" do
    it "should set app" do
      subject.instance_variable_get("@app").should == "foo"
    end

    it "should set version" do
      subject.instance_variable_get("@version").should == "v1"
    end
  end

  describe "#register_strategy" do
    it "should return self" do
      subject.register_strategy("http").should be_a SmartRpc::Client
    end

    it "should set request strategies" do
      subject.register_strategy("http")
      subject.instance_variable_get("@request_strategy_registrar").get("http").should be_a SmartRpc::RequestHandler::Http
    end
  end

  describe "#register_authentication_scheme" do
    before { subject.register_strategy("http") }

    it "should register the authentication scheme for the specific request strategy" do
      subject.register_authentication_scheme("http", "api_key")
      subject.instance_variable_get('@authentication_scheme_registrar').get('api_key', 'http').should be_a SmartRpc::RequestHandler::Http::Authentication::ApiKey
    end

    it "should return the client" do
      subject.register_authentication_scheme("http", "api_key").should eq(subject)
    end
  end

  describe "#register_actions" do
    before{ subject.register_strategy("http") }

    it "should register the new action method" do
      subject.register_actions("http", :list => :get)
      subject.instance_variable_get("@request_strategy_registrar").get("http").should respond_to :list
    end

    it "should return the client" do
      subject.register_actions("http", :list => :get).should eq(subject)
    end
  end

  describe "#request" do
    before do
      subject.register_strategy("http")
      subject.register_authentication_scheme("http", "api_key")
      subject.register_actions('http', :crud)
    end

    it "should perform a request and return the response" do
      stub_request(:get, "http://example.com/rest/v1/client_test_resources/3.json?api_key=ABCDE") \
        .with(:body => "account_id=1") \
        .to_return(:status => 200, :body => {:name => "Test"}.to_json, :headers => {})
      response = subject.request(:action => :read, :for => resource, :via => :http, :authenticate_via => :api_key)
      JSON.parse(response.body).should eq({'name' => 'Test'})
    end
  end
end

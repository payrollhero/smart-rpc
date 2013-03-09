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

  class DumpAss
    def id
      1
    end

    def data_for_read
      {
        :something => :to_read,
        :and       => :something_else
      }
    end
  end

  let(:dumb_ass){ DumpAss.new }
  let(:options){ {:app => 'foo', :version => 'v1'} }
  let(:request_strategy_registrar){ subject.instance_variable_get("@request_strategy_registrar") }

  subject{ SmartRpc::Client.new(options) }

  describe "#initialize" do
    it "should set app" do
      subject.instance_variable_get("@app").should == "foo"
    end

    it "should set version" do
      subject.instance_variable_get("@version").should == "v1"
    end
  end

  describe "#set_scheme" do
    it "should return self" do
      subject.set_scheme("http").should be_a SmartRpc::Client
    end

    it "should set request strategies" do
      subject.set_scheme("http")
      request_strategy_registrar.get("http").should be_a SmartRpc::RequestHandler::Http
    end
  end

  describe "#request" do
    before do
      subject.set_scheme("http")
      subject.register_actions_for('http', :crud)
      stub_request(:get, "http://example.com/rest/v1/dump_asses/1.json?api_key=ABCDE").
       to_return(:status => 200, :body => "", :headers => {})
    end

    it "should do a request" do
      subject.request(:action => :read, :for => dumb_ass, :via => :http)
      a_request(:get, "http://example.com/rest/v1/dump_asses/1.json?api_key=ABCDE").with(:body => "something=to_read&and=something_else").should have_been_made.once
    end
  end

  describe "#register_action_for" do
    before{ subject.set_scheme("http") }

    let(:request_handler){ subject.instance_variable_get("@request_strategy_registrar").get("http") }

    it "should register the new action method" do
      subject.register_actions_for("http", :list => :get)
      request_handler.should respond_to :list
    end
  end
end

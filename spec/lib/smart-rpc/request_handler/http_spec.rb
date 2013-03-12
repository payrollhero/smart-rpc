require 'spec_helper'

describe SmartRpc::RequestHandler::Http do
  let(:request) do
    OpenStruct.new(
      :app => 'foo',
      :authentication_data => {'api_key' => 'ABCDEF'},
      :location => "http://example.com",
      :resource_details => OpenStruct.new(
        :action => :post,
        :location => "open_structs.json",
        :message => {:user => {:name => "Test"}}
      )
    )
  end

  subject{ SmartRpc::RequestHandler::Http.new }

  describe "#perform" do
    before { subject.register_actions_for(:http) }

    context "when the response from the remote application is OK" do
      before :each do
        stub_request(:post, "http://example.com/open_structs.json?api_key=ABCDEF").
          with(:body => "user[name]=Test").
          to_return(:status => 200, :body => "{\"id\":1,\"name\":\"Test\"}", :headers => {})
      end

      it "should return back the response" do
        result = subject.perform(request)
        result.parsed_response.should eq({"name" => "Test", "id" => 1})
      end
    end

    context "when the response from the remote application is a server error" do
      before :each do
        stub_request(:post, "http://example.com/open_structs.json?api_key=ABCDEF").
          with(:body => "user[name]=Test").
          to_return(:status => [500, "Internal Server Error"])
      end

      it "should raise an error" do
        expect{ subject.perform(request) }.to raise_exception(SmartRpc::RequestError)
      end
    end
  end

  describe "#register_actions_for" do
    before do
      stub_request(:post, "http://some-server.com/resource.json").
        to_return(:status => 200, :body => "", :headers => {})
    end

    let(:other_instance){ SmartRpc::RequestHandler::Http.new }

    it "should add action only to the registering instance" do
      subject.register_actions_for(:create => :post)

      subject.should respond_to :create
      other_instance.should_not respond_to :create
    end

    context "given a hash map" do
      it "should map action to equivalent http method" do
        subject.class.should_receive(:post)
        subject.register_actions_for(:create => :post)

        subject.create("http://some-server.com/resource.json")
      end
    end

    context "given an array map" do
      it "should map action to method with the same name" do
        subject.class.should_receive(:post)
        subject.register_actions_for([:post])

        subject.post("http://some-server.com/resource.json")
      end
    end

    context "given a symbol map" do
      it "should map action for the named group" do
        subject.class.should_receive(:post)
        subject.register_actions_for(:crud)

        subject.create("http://some-server.com/resource.json")
        subject.should respond_to :create
        subject.should respond_to :read
        subject.should respond_to :update
        subject.should respond_to :delete
      end
    end

  end

end

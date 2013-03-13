require 'spec_helper'

describe SmartRpc::RequestHandler::Http do
  let(:request) do
    OpenStruct.new(
      :app => 'foo',
      :authentication_data => {'api_key' => 'ABCDEF'},
      :location => "http://example.com",
      :resource_details => OpenStruct.new(
        :action => :create,
        :location => "open_structs.json",
        :message => {:user => {:name => "Test"}}
      )
    )
  end

  subject{ SmartRpc::RequestHandler::Http.new }

  describe "#perform" do
    before { subject.register_actions(:crud) }

    context "when the action requested is registered with the handler" do
      context "when the response from the remote application is OK" do
        before :each do
          stub_request(:post, "http://example.com/open_structs.json?api_key=ABCDEF").
            with(:body => "user[name]=Test").
            to_return(:status => 200, :body => "{\"id\":1,\"name\":\"Test\"}", :headers => {})
        end

        it "should return back the response" do
          result = subject.perform(request)
          JSON.parse(result.body).should eq({"name" => "Test", "id" => 1})
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

    context "when the action is not registered with the handler" do
      it "should raise an exception" do
        request.resource_details.stub!(:action).and_return(:notify)
        expect {subject.perform(request)}.to raise_exception(SmartRpc::ActionNotFoundError)
      end
    end
  end

  describe "#register_actions" do
    before do
      stub_request(:post, "http://some-server.com/resource.json").
        to_return(:status => 200, :body => "", :headers => {})
    end

    context "when a hash of actions mapping to verbs are passed" do
      it "should register the given actions with the http verb" do
        subject.register_actions(:create => :post)
        subject.instance_variable_get('@actions').should eq({:create => :post})
      end
    end

    context "when the mapping passed is :crud" do
      it "should map the crud actions to the http verbs" do
        subject.register_actions(:crud)
        subject.instance_variable_get('@actions').should eq({
          :create => :post,
          :read   => :get,
          :update => :put,
          :delete => :delete
        })
      end
    end
  end
end

require 'spec_helper'

describe SmartRpc::Resource do
  let(:smart_resource) do
    resource = OpenStruct.new(:id => 1, :name => 'Test')
    resource.stub!(:id).and_return(1)
    resource
  end

  subject{ SmartRpc::Resource.new(smart_resource) }

  describe "#initialize" do
    its(:resource){ should eq(smart_resource) }

    it "should extend the resource with a module" do
      subject.resource.should respond_to(:mapped_resource_on_remote)
      subject.resource.should respond_to(:remote_app_resource_uid)
      subject.resource.should respond_to(:path_for_read)
      subject.resource.should respond_to(:path_for_create)
      subject.resource.should respond_to(:path_for_update)
      subject.resource.should respond_to(:path_for_delete)
    end
  end

  describe "#path_for" do
    context "when a method is defined for an action to get the path for the resource" do
      it "should return the path for that action" do
        subject.path_for(:read).should eq("open_structs/1.json")
      end
    end

    context "when a method is not defined for an action to get the path for the resource" do
      it "should return an empty string" do
        subject.path_for(:list).should be_nil
      end
    end
  end

  describe "#data_for" do
    context "when a method is defined for an action to get the parameters for a resource" do
      before :each do
        mod = Module.new do
          def data_for_create
            {:name => self.name}
          end
        end
        subject.resource.extend(mod)
      end

      it "should return the parameters to be sent along with the request" do
        subject.data_for(:create).should eq({:name => "Test"})
      end
    end

    context "when a method is not defined for an action to get the parameters for a resource" do
      it "should return the default parameters to be sent along with the request" do
        subject.data_for(:delete).should eq({})
      end
    end
  end
end

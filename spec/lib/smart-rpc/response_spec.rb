require 'spec_helper'

describe SmartRpc::Response do
  before :each do
    @code = 200
  end

  subject do
    SmartRpc::Response.new(OpenStruct.new(:code => @code, :headers => ["Foo", "Bar"], :body => "{\"test_key\":\"test val\"}"))
  end

  describe "#code" do
    it "should return the code of the response" do
      subject.code.should eq(200)
    end
  end

  describe "#parsed" do
    it "should return the parsed response in JSON format" do
      subject.parsed.should eq({'test_key' => 'test val'})
    end
  end

  describe "#continue?" do
    context "when the response code is between 100 and 200" do
      before {@code = 199}

      it "should return true" do
        subject.continue?.should be_true
      end
    end

    context "when the response code is not between 100 and 200" do
      before {@code = 99}

      it "should return false" do
        subject.continue?.should be_false
      end
    end
  end

  describe "#ok?" do
    context "when the response code is between 200 and 300" do
      before {@code = 299}

      it "should return true" do
        subject.ok?.should be_true
      end
    end

    context "when the response code is not between 200 and 300" do
      before {@code = 199}

      it "should return false" do
        subject.ok?.should be_false
      end
    end
  end

  describe "#redirect?" do
    context "when the response code is between 300 and 400" do
      before {@code = 399}

      it "should return true" do
        subject.redirect?.should be_true
      end
    end

    context "when the response code is not between 300 and 400" do
      before {@code = 299}

      it "should return false" do
        subject.redirect?.should be_false
      end
    end
  end

  describe "#client_error?" do
    context "when the response code is between 400 and 500" do
      before {@code = 499}

      it "should return true" do
        subject.client_error?.should be_true
      end
    end

    context "when the response code is not between 400 and 500" do
      before {@code = 399}

      it "should return false" do
        subject.client_error?.should be_false
      end
    end
  end

  describe "#server_error?" do
    context "when the response code is between 500 and 600" do
      before {@code = 599}

      it "should return true" do
        subject.server_error?.should be_true
      end
    end

    context "when the response code is not between 500 and 600" do
      before {@code = 499}

      it "should return false" do
        subject.server_error?.should be_false
      end
    end
  end

  describe "#method_missing?" do
    context "when a method is defined in the response instance variable" do
      it "should respond to it" do
        subject.headers.should eq(["Foo", "Bar"])
      end
    end

    context "when a method is not defined in the response instance variable" do
      it "should raise an error" do
        expect { subject.foo_bar }.to raise_exception(NoMethodError)
      end
    end
  end

  describe "#respond_to?" do
    context "when a method is defined in the response instance variable" do
      it "should respond to it" do
        subject.should respond_to(:headers)
      end
    end

    context "when a method is not defined in the response instance variable" do
      it "should raise an error" do
        subject.should_not respond_to(:foo_bar)
      end
    end
  end
end

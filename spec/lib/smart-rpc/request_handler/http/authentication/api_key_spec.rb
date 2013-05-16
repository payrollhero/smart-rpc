require 'spec_helper'

describe SmartRpc::RequestHandler::Http::Authentication::ApiKey do

  before do
    SmartRpc::Setting.stub!(:config).and_return({
      'foo' => {
        'authentication' => {
          'api_key' => {
            'api_key' => 'ABCDEF'
          }
        }
      }
    })
  end

  describe "#generate_credentials_for" do
    before{ subject.generate_credentials_for("foo") }

    its(:credentials){ should == {:api_key => 'ABCDEF'} }
  end

end

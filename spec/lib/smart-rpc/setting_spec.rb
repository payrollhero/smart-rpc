require 'spec_helper'

describe SmartRpc::Setting do
  class << SmartRpc::Setting
    def config
      {'foo' => {
          'v1' => {'base_uri' => 'http://example.com'},
          'authentication' => {
            'name_and_password' => {'name' => 'Foo', 'password' => 'BarBazBlah'}
          }
        }
      }
    end
  end

  describe ".request" do
    it "should return the settings for the request" do
      result = SmartRpc::Setting.request('foo', 'v1')
      result.base_uri.should eq("http://example.com")
    end
  end

  describe ".authentication" do
    it "should return the settings for the authentication" do
      result = SmartRpc::Setting.authentication('foo', 'name_and_password')
      result.name.should eq('Foo')
      result.password.should eq('BarBazBlah')
    end
  end
end

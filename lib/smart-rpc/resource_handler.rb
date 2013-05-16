module SmartRpc
  module ResourceHandler
  end
end

Dir[File.dirname(__FILE__) + "/resource_handler/**/*.rb"].each {|f| require f}

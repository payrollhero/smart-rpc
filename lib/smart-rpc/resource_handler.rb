# Namespace for the modules that extend the behavior of the resource.
module SmartRpc
  module ResourceHandler
  end
end

Dir[File.dirname(__FILE__) + "/resource_handler/**/*.rb"].each {|f| require f}

# This class represents the abstraction of the resource object on the client side that is making the request.
# You can decorate the object with custom modules containing path information and parameter information for various actions that are going to be performed on it.
require "retryable"

class SmartRpc::Resource
  attr_reader :resource

  def initialize(resource)
    @resource = resource
    resource_handler_prefix = self.resource.resource_handler_prefix.to_s rescue ""
    possible_handlers = [resource_handler_prefix, self.resource.class.name, "Base"]
    retryable(:on => NameError, :tries => possible_handlers.count, :sleep => 0) do
      handler_name = possible_handlers.shift
      self.resource.extend("SmartRpc::ResourceHandler::#{handler_name}Handler".constantize)
    end
  end

  def path_for(action)
    method_name = "path_for_#{action.to_s}".to_sym
    self.resource.__send__(method_name) if self.resource.respond_to?(method_name)
  end

  def data_for(action)
    method_name = "data_for_#{action.to_s}".to_sym
    self.resource.respond_to?(method_name) ? self.resource.__send__(method_name) : {}
  end
end

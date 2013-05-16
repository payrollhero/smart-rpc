class SmartRpc::Resource
  attr_reader :resource

  def initialize(resource)
    @resource = resource
    index = 0
    resource_handler_prefix = self.resource.resource_handler_prefix.to_s rescue ""
    array = [resource_handler_prefix, self.resource.class.name, "Base"]
    begin
      self.resource.extend("SmartRpc::ResourceHandler::#{array[index]}Handler".constantize)
    rescue NameError
      index += 1
      retry # No, this wont go into an infinite loop because the last option in the array should not throw a NameError
    end
  end

  def path_for(action)
    method_name = "path_for_#{action.to_s}".to_sym
    self.resource.respond_to?(method_name) ? self.resource.__send__(method_name) : ""
  end

  def data_for(action)
    method_name = "data_for_#{action.to_s}".to_sym
    self.resource.respond_to?(method_name) ? self.resource.__send__(method_name) : {}
  end
end

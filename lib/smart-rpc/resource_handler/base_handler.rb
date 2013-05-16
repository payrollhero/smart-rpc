module SmartRpc::ResourceHandler::BaseHandler
  def mapped_resource_on_remote
    self.class.name.underscore.to_sym
  end

  def remote_app_resource_uid; id; end

  def path_for_read
    "/#{self.mapped_resource_on_remote.to_s.pluralize}/#{self.remote_app_resource_uid}.json"
  end

  # You dont want a delegate, cause you would like to override these methods to implement application specific logic.

  def path_for_create
    "/#{self.mapped_resource_on_remote.to_s.pluralize}.json"
  end

  def path_for_update; path_for_read; end

  def path_for_delete; path_for_read; end
end

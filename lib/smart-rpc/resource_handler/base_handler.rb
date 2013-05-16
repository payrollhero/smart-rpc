module SmartRpc::ResourceHandler::BaseHandler

  def mapped_resource_on_remote
    self.class.name.underscore.to_sym
  end

  def remote_app_resource_uid; id; end

  def path_for_read
    "#{path_for_resource_domain}/#{self.remote_app_resource_uid}.json"
  end

  def path_for_create
    "#{path_for_resource_domain}.json"
  end

  alias_method :path_for_update, :path_for_read
  alias_method :path_for_delete, :path_for_read

  private

  def path_for_resource_domain
    self.mapped_resource_on_remote.to_s.pluralize
  end

end

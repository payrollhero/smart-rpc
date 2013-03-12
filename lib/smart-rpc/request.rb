module SmartRpc
  class Request
    attr_accessor :app, :location, :authentication_data, :resource_details

    def initialize(app, version, authentication_scheme)
      @app = app
      settings = SmartRpc::Setting.request(@app, version)
      @location = [settings.base_uri, settings.root_path, version].compact.join("/")
      @authentication_data = authentication_scheme.generate_credentials_for(@app).credentials
    end

    def set_resource_details(resource, action)
      resource = SmartRpc::Resource.new(resource)
      @resource_details = OpenStruct.new(:action => action, :message => resource.data_for(action), :location => resource.path_for(action))
      self
    end
  end
end

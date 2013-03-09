module SmartRpc
  class Request
    attr_accessor :app, :location, :authentication_scheme, :resource_details

    def initialize(app, version)
      @app = app
      settings = SmartRpc::Setting.request(@app, version)
      @location = [settings.base_uri, settings.root_path, version].compact.join("/")
      @authentication_scheme = settings.authentication_scheme
    end

    def set_resource_details(options)
      @resource_details = OpenStruct.new(options)
    end
  end
end

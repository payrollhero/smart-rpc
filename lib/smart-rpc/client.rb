(Dir.glob(File.dirname(__FILE__) + "/*.rb") - [__FILE__]).map {|obj| obj.gsub(/\.rb/, '')}.each do |file_path|
  require file_path
end

class SmartRpc::Client
  def initialize(options)
    @app_name = options.fetch(:app)
    @version = options.fetch(:version)
    @config = SmartRpc::Setting.request(@app_name, @version)
    @request_strategy_registrar = SmartRpc::RequestStrategyRegistrar.new
  end

  def set_scheme(strategy)
    @request_strategy_registrar.register(strategy)
    self
  end

  def request(action, options)
    resource = SmartRpc::Resource.new(options.fetch(:for))
    request_details = OpenStruct.new(
      :request_method => action,
      :message => resource.data_for(action),
      :address => address_for(resource, action),
      :authentication_scheme => @config.authentication_scheme,
      :app_name => @app_name
    )
    @request_strategy_registrar.get(options.fetch(:via)).perform(request_details)
  end

  def register_actions_for(scheme, actions)
    @request_strategy_registrar.get(scheme).register_actions_for(actions)
  end

  private

  def address_for(resource, action)
    [@config.base_uri, @config.root_path, @version, resource.path_for(action)].compact.join("/")
  end
end

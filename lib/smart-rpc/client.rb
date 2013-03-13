(Dir.glob(File.dirname(__FILE__) + "/*.rb") - [__FILE__]).map {|obj| obj.gsub(/\.rb/, '')}.each do |file_path|
  require file_path
end

class SmartRpc::Client
  def initialize(options)
    @app = options.fetch(:app)
    @version = options.fetch(:version)
    @request_strategy_registrar = SmartRpc::RequestStrategyRegistrar.new
    @authentication_scheme_registrar = SmartRpc::AuthenticationSchemeRegistrar.new
  end

  def register_strategy(strategy)
    @request_strategy_registrar.register(strategy)
    self
  end

  def register_authentication_scheme(strategy, scheme)
    @authentication_scheme_registrar.register(scheme, strategy)
    self
  end

  def register_actions(strategy, actions)
    @request_strategy_registrar.get(strategy).register_actions_for(actions)
    self
  end

  def request(options)
    authentication_scheme = @authentication_scheme_registrar.get(options.fetch(:authenticate_via), options.fetch(:via))
    request = SmartRpc::Request.new(@app, @version, authentication_scheme)
    request.set_resource_details(options.fetch(:for), options.fetch(:action))
    @request_strategy_registrar.get(options.fetch(:via)).perform(request)
  end
end

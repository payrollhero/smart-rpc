(Dir.glob(File.dirname(__FILE__) + "/*.rb") - [__FILE__]).map {|obj| obj.gsub(/\.rb/, '')}.each do |file_path|
  require file_path
end

class SmartRpc::Client
  def initialize(options)
    @app = options.fetch(:app)
    @version = options.fetch(:version)
    @request_strategy_registrar = SmartRpc::RequestStrategyRegistrar.new
  end

  def set_scheme(strategy)
    @request_strategy_registrar.register(strategy)
    self
  end

  def register_actions_for(scheme, actions)
    @request_strategy_registrar.get(scheme).register_actions_for(actions)
  end

  def request(action, options)
    request = SmartRpc::Request.new(@app, @version)
    resource = SmartRpc::Resource.new(options.fetch(:for))
    request.set_resource_details(:action => action, :message => resource.data_for(action), :location => resource.path_for(action))
    @request_strategy_registrar.get(options.fetch(:via)).perform(request)
  end
end

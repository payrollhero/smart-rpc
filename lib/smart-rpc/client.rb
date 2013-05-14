(Dir.glob(File.dirname(__FILE__) + "/*.rb") - [__FILE__]).map {|obj| obj.gsub(/\.rb/, '')}.each do |file_path|
  require file_path
end

# This class is the main user facing class.
# One can initiate a new client for every class and register the strategy that one wants to use for performing requests.
# The gem provides only the http strategy for performing the requests.
# But you can define your own strategies.
# You need to register the authentication schemes for your strategy if you want to have one. You can also opt out of it.
# You also need to register the actions that you want to perform for the startegy.
# For example : For the http strategy you can pass :crud or pass a hash like :create => :post to register the actions.
# Finally once the client is set up, you can perform multiple requests with that client.
# On each request you can choose which strategy to apply, which authentication scheme to use and what action to perform.
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
    @request_strategy_registrar.get(strategy).register_actions(actions)
    self
  end

  def request(options)
    authentication_scheme = @authentication_scheme_registrar.get(options[:authenticate_via], options.fetch(:via))
    request = SmartRpc::Request.new(@app, @version, authentication_scheme)
    request.set_resource_details(options.fetch(:for), options.fetch(:action))
    @request_strategy_registrar.get(options.fetch(:via)).perform(request)
  end
end

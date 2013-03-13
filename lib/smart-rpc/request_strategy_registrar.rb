# This class basically is a registrar for various strategies present.
# You are not allowed to use a request strategy that you have not registered.
module SmartRpc
  class RequestStrategyRegistrar
    def initialize
      register(:base)
    end

    def register(strategy)
      @registered_strategies ||= {}
      @registered_strategies[strategy.to_sym] = "SmartRpc::RequestHandler::#{strategy.to_s.camelize}".constantize.new
    end

    def get(strategy)
      begin
        @registered_strategies.fetch(strategy.to_sym)
      rescue IndexError
        raise SmartRpc::StrategyNotFoundError.new(strategy)
      end
    end
  end
end

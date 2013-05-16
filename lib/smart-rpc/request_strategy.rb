module SmartRpc
  class RequestStrategy
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
        raise SmartRpc::StrategyNotFoundError.new(strategy.to_s)
      end
    end
  end
end

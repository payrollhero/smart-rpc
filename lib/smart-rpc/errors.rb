module SmartRpc
  class SmartRpcError < StandardError
  end

  class RequestError < SmartRpcError
    def initialize(response)
      super(response.response.message)
    end
  end

  class StrategyNotFoundError < SmartRpcError
    def initialize(strategy)
      super(strategy.to_s + " is not registered as a strategy")
    end
  end

  class AuthenticationSchemeNotFoundError < SmartRpcError
    def initialize(scheme, strategy)
      super(scheme.to_s + " is not registered as an authentication scheme for " + strategy.to_s)
    end
  end

  class ActionNotFoundError < SmartRpcError
    def initialize(action, strategy)
      super(action.to_s + " is not registered as an action for " + strategy.to_s)
    end
  end
end

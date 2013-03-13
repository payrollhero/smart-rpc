# This file contains all the error classes applicable for this gem.
module SmartRpc
  class SmartRpcError < StandardError
  end

  # This error is raised when the request fails
  class RequestError < SmartRpcError
    def initialize(response)
      super(response.response.message)
    end
  end

  # This error is raised when a strategy is not registered
  class StrategyNotFoundError < SmartRpcError
    def initialize(strategy)
      super(strategy.to_s + " is not registered as a strategy")
    end
  end

  # This error is raised when a authentication scheme is not registered
  class AuthenticationSchemeNotFoundError < SmartRpcError
    def initialize(scheme, strategy)
      super(scheme.to_s + " is not registered as an authentication scheme for " + strategy.to_s)
    end
  end

  # This error is raised when an action is not registered
  class ActionNotFoundError < SmartRpcError
    def initialize(action, strategy)
      super(action.to_s + " is not registered as an action for " + strategy.to_s)
    end
  end
end

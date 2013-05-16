module SmartRpc
  class SmartRpcError < StandardError
  end

  class RequestError < SmartRpcError
    def initialize(response)
      super(response.response.message)
    end
  end

  class StrategyNotFoundError < IndexError
    def initialize(key)
      super(key + " is not registered as a strategy")
    end
  end
end

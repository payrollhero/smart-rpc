module SmartRpc
  class AuthenticationSchemeRegistrar
    def initialize
      @schemes = Hash.new do |hash, key|
        begin
          "SmartRpc::RequestHandler::#{key.to_s.camelize}".constantize
        rescue NameError
          raise SmartRpc::StrategyNotFoundError.new(key)
        end
        hash[key] = {}
      end
    end

    def register(scheme, strategy)
      @schemes[strategy.to_sym][scheme.to_sym] = "SmartRpc::RequestHandler::#{strategy.to_s.camelize}::Authentication::#{scheme.to_s.camelize}".constantize.new
      self
    end

    def get(scheme, strategy)
      raise SmartRpc::StrategyNotFoundError.new(strategy) unless @schemes.has_key?(strategy.to_sym)
      begin
        @schemes.fetch(strategy.to_sym).fetch(scheme.to_sym)
      rescue IndexError
        raise SmartRpc::AuthenticationSchemeNotFoundError.new(scheme, strategy)
      end
    end
  end
end

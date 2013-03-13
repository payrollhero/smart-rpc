module SmartRpc
  module RequestHandler
    class Http
      class WrappedResponse
        def initialize(raw_response)
          @raw_response = raw_response
        end

        def code
          @raw_response.code
        end

        def parsed
          JSON.parse( @raw_response.body )
        end

        def continue?
          (100...200) === code
        end

        def ok?
          (200...300) === code
        end

        def redirect?
          (300...400) === code
        end

        def client_error?
          (400...500) === code
        end

        def server_error?
          (500...600) === code
        end

        def method_missing(name, *args, &block)
          @raw_response.respond_to?(name) ? @raw_response.__send__(name, *args, &block) : super
        end

        def respond_to?(name)
          @raw_response.respond_to?(name) || super
        end
      end
    end
  end
end

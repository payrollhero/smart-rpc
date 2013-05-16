module SmartRpc
  module RequestHandler
    class Http
      require "smart-rpc/request_handler/http/authentication"

      class AuthenticationScheme
        def initialize
          @schemes = {}
        end

        def register(scheme)
          @schemes[scheme.to_sym] = "SmartRpc::RequestHandler::Http::Authentication::#{scheme.to_s.camelize}".constantize
        end

        def fetch_details(scheme, app_name)
          authentication = @schemes.fetch(scheme.to_sym).new
          authentication.generate_credentials_for(app_name)
          authentication.credentials
        end
      end
    end
  end
end

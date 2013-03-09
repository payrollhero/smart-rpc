module SmartRpc
  module RequestHandler
    class Http
      module Authentication
        require 'smart-rpc/request_handler/http/authentication/base'

        class ApiKey < Base
          def generate_credentials_for(app_name)
            @credentials[:api_key] = SmartRpc::Setting.authentication(app_name, "api_key").api_key
          end
        end
      end
    end
  end
end
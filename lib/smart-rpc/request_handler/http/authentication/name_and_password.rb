# This class represents the authentication scheme - name and password.
module SmartRpc
  module RequestHandler
    class Http
      module Authentication
        require 'smart-rpc/request_handler/http/authentication/base'

        class NameAndPassword < Base
          def generate_credentials_for(app_name)
            @credentials[:app_name] = app_name
            @credentials[:app_secret] = SmartRpc::Setting.authentication(app_name, "name_and_password").password
            self
          end
        end
      end
    end
  end
end

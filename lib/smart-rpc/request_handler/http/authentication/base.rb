module SmartRpc
  module RequestHandler
    class Http
      module Authentication
        class Base
          attr_reader :credentials

          def initialize
            @credentials = {}
          end

          def generate_credentials_for(app_name)
            raise NotImplementedError
          end
        end
      end
    end
  end
end

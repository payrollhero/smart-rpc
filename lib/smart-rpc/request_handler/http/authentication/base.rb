# The base class for all authentication schemes for http strategy.
# This is kind of an abstract class, rather provides the functionality of a null object.
# The child classes must implement generate_credentials_for method for a more concrete implementation.
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
            self
          end
        end
      end
    end
  end
end

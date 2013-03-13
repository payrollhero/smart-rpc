# The base class for all kinds of handlers.
# This is an abstract class. The child classes inheriting this class must implement the 2 methods - perform and register_actions
module SmartRpc
  module RequestHandler
    class Base
      def initialize
        @actions = {}
      end

      def perform(request_details)
        raise NotImplementedError
      end

      def register_actions(actions)
        raise NotImplementedError
      end
    end
  end
end


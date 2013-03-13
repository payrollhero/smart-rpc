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


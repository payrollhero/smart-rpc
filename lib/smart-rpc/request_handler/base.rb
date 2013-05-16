module SmartRpc
  module RequestHandler
    class Base
      def perform(request_details)
        raise NotImplementedError
      end
    end
  end
end


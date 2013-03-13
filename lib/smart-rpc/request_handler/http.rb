require "httmultiparty"

module SmartRpc
  module RequestHandler
    class Http < Base
      require "smart-rpc/request_handler/http/authentication/api_key"
      require "smart-rpc/request_handler/http/authentication/name_and_password"
      require "smart-rpc/request_handler/http/wrapped_response.rb"

      include HTTMultiParty
      format :json

      def perform(request)
        uri = URI.parse([request.location, request.resource_details.location].compact.join("/"))
        raw_response = self.__send__(request.resource_details.action, uri.to_s, :default_params => request.authentication_data, :body => request.resource_details.message)
        wrapped_response = SmartRpc::RequestHandler::Http::WrappedResponse.new(raw_response)
        raise SmartRpc::RequestError.new(wrapped_response) if wrapped_response.server_error?
        wrapped_response.response
      end

      def register_http_actions
        register_actions_for([
          :post,
          :get,
          :put,
          :delete
        ])
      end

      def register_crud_actions
        register_actions_for({
          :create => :post,
          :read   => :get,
          :update => :put,
          :delete => :delete
        })
      end

      def register_actions_for(action_map)
        case action_map
        when Symbol
          self.__send__("register_#{action_map}_actions")
        when Array
          action_map.each do |registered_method|
            map_method registered_method
          end
        when Hash
          action_map.each do |registered_method, http_method|
            map_method registered_method, :to => http_method
          end
        end
      end

      private

      def map_method(registered_method, options = {})
        http_method = options[:to] || registered_method

        self.singleton_class.send(:define_method, registered_method) do |*args, &block|
          self.class.__send__(http_method, *args, &block)
        end
      end
    end
  end
end

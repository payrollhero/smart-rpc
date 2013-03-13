# This class deals with handling the http strategy.
# It implements 2 basic methods that the base class does not implement - perform and register_actions.
# For now we only support json format for making http requests.
require "httmultiparty"

module SmartRpc
  module RequestHandler
    class Http < Base
      require "smart-rpc/request_handler/http/authentication/api_key"
      require "smart-rpc/request_handler/http/authentication/name_and_password"
      require "smart-rpc/request_handler/http/wrapped_response.rb"

      include HTTMultiParty
      format :json

      def initialize
        @actions = {}
      end

      def perform(request)
        uri = URI.parse([request.location, request.resource_details.location].compact.join("/"))
        action = request.resource_details.action
        begin
          http_verb = @actions.fetch(action.to_sym)
        rescue IndexError
          raise SmartRpc::ActionNotFoundError.new(action, :http)
        end
        raw_response = self.class.__send__(http_verb, uri.to_s, :default_params => request.authentication_data, :body => request.resource_details.message)
        wrapped_response = SmartRpc::RequestHandler::Http::WrappedResponse.new(raw_response)
        raise SmartRpc::RequestError.new(wrapped_response) if wrapped_response.server_error?
        wrapped_response.response
      end

      def register_actions(action_map)
        action_map = {
          :create => :post,
          :read   => :get,
          :update => :put,
          :delete => :delete
        } if action_map == :crud
        @actions.reverse_merge!(action_map.symbolize_keys!)
      end
    end
  end
end

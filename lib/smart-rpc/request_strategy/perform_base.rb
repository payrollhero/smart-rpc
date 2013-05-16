module SmartRpc::RequestStrategy::PerformBase
  extend self

  def perform(request_details)
    URI.parse(request_details.base_uri) # Needs to be there to raise an error if your base url is not correct or empty
    raw_response = SmartRpc::Request.__send__(request_details.type, request_details.path, :base_uri => request_details.base_uri, :default_params => request_details.default_params, :body => request_details.query)
    response     = SmartRpc::Response.new(raw_response)
    raise SmartRpc::RequestError.new(response) if response.server_error?
    response
  end
end

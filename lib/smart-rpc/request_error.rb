class SmartRpc::RequestError < RuntimeError
  def initialize(response)
    super(response.response.message)
  end
end

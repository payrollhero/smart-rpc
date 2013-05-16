class SmartRpc::Response
  def initialize(response)
    @response = response
  end

  def code
    @response.code
  end

  def parsed
    JSON.parse( @response.body )
  end

  def continue?
    code.in?(100..199)
  end

  def ok?
    code.in?(200..299)
  end

  def redirect?
    code.in?(300..399)
  end

  def client_error?
    code.in?(400..499)
  end

  def server_error?
    code.in?(500..599)
  end

  def method_missing(name, *args, &block)
    @response.respond_to?(name) ? @response.__send__(name, *args, &block) : super
  end

  def respond_to_missing?(name, include_private = false)
    @response.respond_to?(name) || super
  end
end

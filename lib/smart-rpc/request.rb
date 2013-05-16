(Dir.glob(File.dirname(__FILE__) + "/*.rb") - [__FILE__]).map {|obj| obj.gsub(/\.rb/, '')}.each do |file_path|
  require file_path
end

require "httmultiparty"

Struct.new("RequestDetail", :type, :base_uri, :path, :default_params, :query)

class SmartRpc::Request

  include HTTMultiParty

  format :json

  def initialize(options)
    @version = options.fetch(:version)
    @config  = SmartRpc.config(options.fetch(:app), @version)

    generate_methods(options[:actions] || crud_actions)
  end

  private

  def generate_methods(action_maps)
    klass = class << self; self; end

    action_maps.each do |action, request_type|
      klass.send(:define_method, "#{action}!") do |object, *args|
        options = args.extract_options!
        options[:strategy] ||= :base

        begin
          self.extend("SmartRpc::RequestStrategy::Perform#{options[:strategy].to_s.camelize}".constantize)
        rescue NameError => ex
          warn "#{ex.message}. Please define a module of your own in app/smart-rpc/request_strategy if you want a strategy other than a http request."
          self.extend(SmartRpc::RequestStrategy::PerformBase)
        end

        resource = SmartRpc::Resource.new( object )

        self.perform( Struct::RequestDetail.new( request_type, @config.base_uri, api_path_to(resource, action), api_credential, resource.data_for(action) ))
      end
    end
  end

  # These actions are for a resource.
  # List is not suitable for a single resource.
  # So please do not include list in the CRUD actions.
  def crud_actions
    {
      :create => :post,
      :read   => :get,
      :update => :put,
      :delete => :delete
    }
  end

  def api_credential
    _api_credential = {}

    case @config.authentication_scheme
    when "name_and_password"
      _api_credential[@config.app_name_key   || :app_name]   = @config.app_name
      _api_credential[@config.app_secret_key || :app_secret] = @config.app_secret
    else # default: :api_key_only
      _api_credential[:api_key] = @config.secret
    end

    _api_credential
  end

  def api_path_to(resource, action)
    _api_path  = ""
    _api_path += "/#{@config.root_path}" if @config.root_path
    _api_path += "/#{ @version }#{ resource.path_for(action) }"

    _api_path
  end

end

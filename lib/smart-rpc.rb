module SmartRpc
  class << self
    def config(app_name, version)
      OpenStruct.new(self.settings.fetch(app_name).fetch(version))
    end
  end
end

require "smart-rpc/request"

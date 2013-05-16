module SmartRpc
  module Setting
    class << self
      def request(app_name, version)
        OpenStruct.new(self.config.fetch(app_name).fetch(version))
      end

      def authentication(app_name, scheme)
        OpenStruct.new(self.config.fetch(app_name).fetch("authentication").fetch(scheme))
      end
    end
  end
end

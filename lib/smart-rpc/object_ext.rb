class Object
  unless respond_to?(:singleton_class) # exists in 1.9.2
    # http://apidock.com/ruby/v1_9_2_180/Object/singleton_class
    def singleton_class
      class << self
        self
      end
    end
  end
end
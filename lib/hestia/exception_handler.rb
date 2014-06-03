require 'fog'

module ExceptionHandler

 def check_exceptions_on_connection(*args)
    clazz = self
    options = (Hash === args.last) ? args.pop : {}
    methods = args
    callback = clazz.instance_method(options[:callback]) if options.key?(:callback)
    methods.each do |m|
      im = self.instance_method(m)
      self.send(:define_method, m) do |*args|
        begin
          im.bind(self).call(*args)
        rescue => e
          callback.bind(self).call(e)
        end
      end
    end
  end

end


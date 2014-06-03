require 'thor'
require 'thor/group'
require 'thor/actions'
class Hestia

  class Base < Thor::Group
    include Thor::Actions

    class_option :provider, :type => :string,
                 :desc => "Provider to use for this command",
                 :default => "default",
                 :aliases => ["--provider","-p"]

    def self.register(name, usage, description, opts={})
      CLI.register(self, name, usage, description, opts)
    end

  end

end

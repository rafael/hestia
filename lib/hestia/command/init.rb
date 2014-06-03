require 'ruby-debug'
require 'fileutils'
class Hestia
  module Command
    class InitCommand < Base
      include FileUtils
      argument :path, :type => :string
      register "init", "init path/", "Create file configuration templates in the given directory"
      def execute
        src_machines = File.expand_path(
              File.join(
                File.dirname(__FILE__),
                '..',
                '..',
                '..',
                'config',
                'machines.yml.example'))
        dest_machines = File.expand_path(File.join(path, "machines.yml")) 
        cp(src_machines, dest_machines)

        src_providers = File.expand_path(
              File.join(
                File.dirname(__FILE__),
                '..',
                '..',
                '..',
                'config',
                'providers.yml.example'))
        dest_providers = File.expand_path(File.join(path, "providers.yml")) 
        cp(src_providers, dest_providers)

        exit(0)
      end
    end
  end
end

class Hestia
  module Command
    class StartCommand < Base
      argument :machine_name, :type => :string
      register "start", "start machine name", "Turns on an instance defined in the config file (e.g hestia stop crawler)"
      def execute
        return "You need to provide a machine name as paramater" if machine_name.nil?
        machine  = Hestia.machine(machine_name)
        provider = Hestia.provider(options[:provider])
        if machine.nil?
          puts "Couldn't find machine #{machine_name} in the configuration file"
          exit(1)
        else
          ec2_interface = Ec2Interface.new(provider)
          server = ec2_interface.find_instance(machine)
          return "Couldn't find the instance in amazon" if server.nil?
          ec2_interface.start_instance(server)
          puts "\x1B[35m Waiting for server to boot. \x1B[0m"
          server.wait_for { print "\x1B[32m.\x1B[0m"; ready? }
          puts "\n\x1B[35m Done. \x1B[0m"
        end
      end
    end
  end
end

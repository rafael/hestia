class Hestia
  module Command
    class InfoCommand < Base
      argument :machine_name, :type => :string
      register "stop", "stop machine_name", "Turns off an instance defined in the config file."
      def execute
        return "You need to provide a machine name as paramater" if machine_name.nil?
        machine  = Hestia.machine(machine_name)
        provider = Hestia.provider(options[:provider])
        if machine.empty?
          puts "Couldn't find machine #{machine_name} in the configuration file"
          exit(1)
        else
          ec2_interface = Ec2Interface.new(provider)
          server = ec2_interface.find_instance(machine)
          return "Couldn't find the instance in amazon" if server.nil?
          ec2_interface.stop_instance(server)
          puts "Command sent succesfully to amazon" 
          exit(0)
        end
      end
    end
  end
end

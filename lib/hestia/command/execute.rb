class Hestia
  module Command
    class ExecuteCommand < Base
      desc "Executes remotely a commmand in the given machine. A ssh_private_key must exists in machines.yml for the given machine."
      argument :machine_name, :type => :string
      class_option :command, :type => :string, 
                   :required => true,
                   :aliases => ["--command","-c"]
      register "execute", "execute machine_name -c 'ls -la'", desc
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
          responses = ec2_interface.execute_command_in_instance(server, 
                                                    machine[:ssh_private_key], 
                                                    options[:command],
                                                    machine[:username])
          puts " \x1B[32m #{responses.last.stdout}\x1B[0m"
          exit(responses.last.status)
        end
      end
    end
  end
end

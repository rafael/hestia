class Hestia
  module Command
    class BindIpCommand < Base
      argument :machine_name, :type => :string
      class_option :ip, :type => :string, 
                   :required => true,
                   :aliases => ["--ip-address","-i"]
      register "bind_ip", "bind_ip machine_name -i ip", "Bind the a  public ip to the given ec2 instance."
      def execute
        return "You need to provide an ip for the machine" if machine_name.nil?
        machine  = Hestia.machine(machine_name)
        provider = Hestia.provider(options[:provider])
        if machine.empty?
          puts "Couldn't find machine #{machine_name} in the configuration file"
          exit(1)
        else
          ec2_interface = Ec2Interface.new(provider)
          server = ec2_interface.find_instance(machine)
          return "Couldn't find the instance in amazon" if server.nil?
          ec2_interface.bind_ip(server, options[:ip])
          puts "Command sent succesfully to amazon" 
          exit(0)
        end
      end
    end
  end
end

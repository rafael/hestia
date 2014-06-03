require 'ruby-debug'
class Hestia
  module Command
    class StopCommand < Base
      argument :machine_name, :type => :string
      register "info", "info machine_name", "Returns current info of the given machine"
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
          if server.nil?
            puts "Couldn't find the instance in amazon"  
            exit(1)
          end
          puts "Instance ID: #{server.id}"
          puts "State: #{server.state}"
          puts "Zone: #{server.availability_zone}"
          puts "Public IP: #{server.public_ip_address}"
          puts "Private IP: #{server.private_ip_address}"
          server.tags.each {|(key, value)| puts "#{key}: #{value}"}
          exit(0)
        end
      end
    end
  end
end

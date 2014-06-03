class Hestia
  module Command
    class VolumeBackupCommand < Base
      argument :machine_name, :type => :string
      class_option :snapshot_id, :type => :string,
                 :desc => "Identifier for the snapshot",
                 :aliases => ["--snapshot-name","-n"]
      register "vbackup", "vbackup machine_name", "Creates a volume backup of the given instance"
      def execute
        machine = Hestia.machine(machine_name)
        if machine.nil?
          puts "\x1B[31m* Couldn't find machine #{machine_name} in the configuration file.\x1B[0m"
        else
          provider = Hestia.provider(options[:provider])
          ec2_interface = Ec2Interface.new(provider)
          server = ec2_interface.find_instance_by_ip(machine[:ip])
          return "\x1B[31m* couldn't find server #{machine_name} with ip #{machine[:ip]} in amazon\x1b[0m" if server.nil?
          if ec2_interface.create_volume_backup(server) 
            puts "\x1B[32m* Snapshot request for #{machine_name} succesfully sent to amazon\x1B[0m"
          else
            puts "\x1B[31m* There was a problem creating volume backup for #{machine_name}\x1B[0m"
          end
        end
      end
    end
  end
end

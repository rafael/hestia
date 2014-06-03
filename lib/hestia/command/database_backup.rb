class Hestia
  module Command

    class DatabaseBackupCommand < Base
      argument :db_id, :type => :string
      class_option :snapshot_id, :type => :string,
                 :desc => "Identifier for the snapshot",
                 :aliases => ["--snapshot-name","-n"]
      register "dbackup", "dbackup db_id", "Creates a backup of the given db instance" 
      def execute
        provider = Hestia.provider(options[:provider])
        rds_interface = RdsInterface.new(provider)
        if rds_interface.create_database_backup(db_id,options[:snapshot_id])
          puts "\x1B[32m* Snapshot request for #{db_id} succesfully sent to amazon\x1B[0m"
        else
          puts "\x1B[31m* There was a problem creating backup for #{db_id}\x1B[0m"
        end
      end
    end
  end
end

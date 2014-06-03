require 'fog'
require 'hestia/exception_handler'

class RdsInterface


  ############
  ## Mixins ##
  ############

  extend ExceptionHandler

  #########################
  ## Attributes Accesors ##
  #########################

  attr_accessor :connection

  ######################
  ## Instance Methods ##
  ######################

  def initialize(opts = {})
    @connection ||= Fog::AWS::RDS.new(
            :region => opts[:region] || 'us-east-1',
            :aws_access_key_id => opts[:aws_access_key_id],
            :aws_secret_access_key  => opts[:aws_secret_access_key])
  end

  def create_database_backup(db_id,snapshot_id=nil)
    response = nil
    if snapshot_id.nil?
      response = connection.create_db_snapshot(db_id, 
              "#{db_id}-snapshot-#{Time.now.strftime("%m-%d-%Y")}")
    else
      response = connection.create_db_snapshot(db_id, snapshot_id)
    end
    if response && response.status == 200
      return true 
    else
      false
    end
  end

  def handle_error(e)
    puts "\x1B[31m* There was a problem with fog:\x1B[0m"
    puts " \x1B[31m#{e.inspect}\x1B[0m"
    exit(1)
  end

  check_exceptions_on_connection :create_database_backup,
                                 :callback => :handle_error
end

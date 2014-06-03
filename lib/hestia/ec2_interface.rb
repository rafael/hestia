require 'fog'
require 'hestia/exception_handler'

class Ec2Interface

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
    @connection ||= Fog::Compute.new(
      :provider => opts[:provider] || 'AWS',
      :region => opts[:region] || 'us-east-1',
      :aws_access_key_id => opts[:aws_access_key_id],
      :aws_secret_access_key  => opts[:aws_secret_access_key])
  end

  ## This methods expects a hash with the identifiers for a server
  ##

  def find_instance(opts = {})
    if opts[:ip]
      find_instance_by_ip(opts[:ip])
    elsif opts[:instance_id]
      find_instance_by_id(opts[:instance_id])
    else
      return nil
    end
  end

  def find_instance_by_ip(ip)
    @connection.servers.detect do |server|
      server.public_ip_address == ip
    end
  end

  def find_instance_by_id(instance_id)
    @connection.servers.detect do |server|
      server.id == instance_id
    end
  end

  def create_volume_backup(instance, snapshot_id=nil)
    response = nil
    volume_id = instance.block_device_mapping.first["volumeId"]
    if snapshot_id.nil?
      response = connection.create_snapshot(volume_id,
                                            "noomii-volume-#{volume_id}-#{Time.now.strftime("%m-%d-%Y")}")
    else
      response = connection.create_snapshot(volume_id,snapshot_id)
    end
    if response && response.status == 200
      return true
    else
      return false
    end

  end

  def start_instance(instance)
   instance.start
   true
  end

  def stop_instance(instance)
    if instance.ready?
      instance.stop
      true
    else
      false
    end
  end

  def bind_ip(instance, ip)
    @connection.associate_address(instance.id, ip)
  end

  def execute_command_in_instance(instance, ssh_private_key_path, command, username = nil)
    private_key = File.read(ssh_private_key_path)
    instance.private_key= private_key
    instance.username = username unless username.nil?
    responses = instance.ssh(command)
  end

  def handle_error(e)
    puts "\x1B[31m* There was a problem while executing your request:\x1B[0m"
    puts " \x1B[31m#{e.message}\x1B[0m"
    exit(1)
  end

  check_exceptions_on_connection :find_instance_by_ip,
                                 :create_volume_backup,
                                 :start_instance,
                                 :stop_instance,
                                 :bind_ip,
                                 :callback => :handle_error
end

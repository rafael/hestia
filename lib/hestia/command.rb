require 'active_support/hash_with_indifferent_access'
require 'hestia/cli'

require 'hestia/ec2_interface'
require 'hestia/rds_interface'
# Load all commands
require 'hestia/command/base'
Dir[File.dirname(__FILE__) + '/command/*.rb'].each {|file| require file }

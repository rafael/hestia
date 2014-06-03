require 'yaml'
require 'hestia/command'
require 'active_support/hash_with_indifferent_access'

class Hestia

  class << self
    attr_writer :machines_config_path
    attr_writer :providers_config_path
  end

  #
  #
  #
  def self.machine(name)
    @machines ||= parse_machines_yaml
    ActiveSupport::HashWithIndifferentAccess.new(@machines[name])
  end

  def self.provider(name)
    @providers ||= parse_providers_yaml
    ActiveSupport::HashWithIndifferentAccess.new(@providers[name])
  end

  #
  #
  #
  def self.machines_config_path(base_path = ".")
    path = File.expand_path(
              File.join(
                base_path,
                'machines.yml'))
    @machines_config_path ||= path
  end


  def self.create_machines
    @machines ||= parse_machines_yaml
  end

  def self.providers_config_path(base_path = ".")
    path = File.expand_path(
              File.join(
                base_path,
                'providers.yml'))
    @providers_config_path ||= path
  end

  protected

  #
  #
  #
  def self.parse_machines_yaml
    begin
      yaml_hash = YAML.load_file(self.machines_config_path)
    rescue Errno::ENOENT
      puts "Couldn't find configuration file for machine.yml. Try to run hestia init first"
      exit(1)
    end
  end

  def self.parse_providers_yaml
    begin
    yaml_hash = YAML.load_file(self.providers_config_path)
    rescue Errno::ENOENT
      puts "Couldn't find configuration file for providers.yml. Try to run hestia init first"
      exit(1)
    end
  end

end

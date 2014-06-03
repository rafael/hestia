require 'helper'

describe Hestia do

  def setup_machines_config_fixture
    path = File.join(
              File.dirname(__FILE__),
              'fixtures',
              'machines.yml')
    Hestia.machines_config_path = path
  end

  before do
    setup_machines_config_fixture
  end

  it 'parses machines file' do
    Hestia.machine('production')['ip'].wont_be_nil
    Hestia.machine('production')['identifier'].wont_be_nil

    Hestia.machine('crawler')['ip'].must_be_nil
    Hestia.machine('production')['identifier'].wont_be_nil
  end

end
